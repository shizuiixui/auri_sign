import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class GestureDetector {
  Interpreter? _interpreter;
  List<String> labels = [];
  bool _isInitialized = false;
  late List<int> _imageBuffer;
  int _frameCount = 0;
  int _skipFrames = 3; // Process every 4th frame
  int _inputSize = 224; // model input size (assumed)

  // Tensor shapes (filled after loading model)
  List<int>? _inputShape;
  List<int>? _outputShape;
  int _outputLen = 0;
  bool _inputIsUint8 = false;

  // simple stability filter
  String _lastPredicted = '';
  int _consecutiveCount = 0;
  int _requiredConsecutive = 2;
  double _minConfidence = 0.5;

  Future<void> loadModel() async {
    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset(
        'assets/models/sign_model.tflite',
      );

      // Initialize image buffer (will be resized per frame)
      _imageBuffer = List<int>.filled(0, 0);

      // Try to infer input/output shapes from the model
      try {
        final interp = _interpreter!;
        final inputTensors = interp.getInputTensors();
        if (inputTensors.isNotEmpty) {
          _inputShape = inputTensors[0].shape;
          // detect input type
          try {
            _inputIsUint8 = inputTensors[0].type
                .toString()
                .toLowerCase()
                .contains('uint');
          } catch (_) {}
          if (_inputShape != null && _inputShape!.length >= 3) {
            // common shape is [1, H, W, C]
            _inputSize = _inputShape!.length == 4
                ? _inputShape![1]
                : _inputSize;
          }
        }

        final outputTensors = interp.getOutputTensors();
        if (outputTensors.isNotEmpty) {
          _outputShape = outputTensors[0].shape;
          _outputLen = _outputShape!.reduce((a, b) => a * b);
        }
      } catch (e) {
        print('Could not read tensor shapes: $e');
      }

      // Load labels (after we know model output shape)
      labels = await _loadLabels('assets/models/gesture_labels.txt');

      // Warn if label count doesn't match model output
      if (_outputShape != null && _outputShape!.isNotEmpty) {
        final int expected = _outputShape!.last;
        if (labels.length != expected) {
          print(
            'Warning: labels length (${labels.length}) does not match model output length ($expected).',
          );
        }
      }
      print('Model input shape: $_inputShape, uint8?=$_inputIsUint8');
      print('Model output shape: $_outputShape len=$_outputLen');

      _isInitialized = true;
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  Future<List<String>> _loadLabels(String labelPath) async {
    try {
      final raw = await rootBundle.loadString(labelPath);
      final lines = raw
          .split(RegExp(r"\r?\n"))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return lines;
    } catch (e) {
      print('Error loading labels: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> runInference(CameraImage image) async {
    if (!_isInitialized) {
      // Attempt to initialize the model on-demand to avoid late-init errors
      try {
        await loadModel();
      } catch (e) {
        print('Error initializing model on-demand: $e');
        return {'gesture': 'Error', 'confidence': 0.0, 'allScores': []};
      }
    }

    // Skip frames to improve performance
    _frameCount++;
    if (_frameCount % (_skipFrames + 1) != 0) {
      return {'gesture': 'Skipped', 'confidence': 0.0, 'allScores': []};
    }

    try {
      // Convert camera image to RGB buffer
      _convertYUV420ToRGB(image);

      // Build and normalize input by center-cropping and resizing manually
      final int width = image.width;
      final int height = image.height;

      final int srcSize = width < height ? width : height;
      final int xOffset = ((width - srcSize) / 2).round();
      final int yOffset = ((height - srcSize) / 2).round();

      final Float32List flatInput = Float32List(_inputSize * _inputSize * 3);
      int idx = 0;

      // Nearest-neighbor resize from srcSize -> _inputSize and normalize
      for (int y = 0; y < _inputSize; y++) {
        final double srcY = y * srcSize / _inputSize;
        final int iSrcY = srcY.floor().clamp(0, srcSize - 1);
        for (int x = 0; x < _inputSize; x++) {
          final double srcX = x * srcSize / _inputSize;
          final int iSrcX = srcX.floor().clamp(0, srcSize - 1);

          final int srcIndex =
              ((yOffset + iSrcY) * width + (xOffset + iSrcX)) * 3;
          final int r = _imageBuffer[srcIndex];
          final int g = _imageBuffer[srcIndex + 1];
          final int b = _imageBuffer[srcIndex + 2];

          flatInput[idx++] = r / 255.0;
          flatInput[idx++] = g / 255.0;
          flatInput[idx++] = b / 255.0;
        }
      }

      // Build nested input following model input layout (NHWC or NCHW)
      dynamic nestedInput;
      if (_inputShape != null &&
          _inputShape!.isNotEmpty &&
          _inputShape!.length == 4) {
        final int batch = _inputShape![0];
        // Detect channel position
        final bool channelsLast = _inputShape![3] == 3;
        final int h = channelsLast ? _inputShape![1] : _inputShape![2];
        final int w = channelsLast ? _inputShape![2] : _inputShape![3];
        final int c = 3;

        if (channelsLast) {
          nestedInput = List.generate(batch, (_) {
            return List.generate(h, (ry) {
              return List.generate(w, (rx) {
                final int base = (ry * w + rx) * c;
                return List.generate(c, (ch) {
                  final val = flatInput[base + ch];
                  return _inputIsUint8 ? (val * 255).toInt() : val;
                });
              });
            });
          });
        } else {
          // NCHW
          nestedInput = List.generate(batch, (_) {
            return List.generate(c, (ch) {
              return List.generate(h, (ry) {
                return List.generate(w, (rx) {
                  final int base = (ry * w + rx) * c + ch;
                  final val = flatInput[base];
                  return _inputIsUint8 ? (val * 255).toInt() : val;
                });
              });
            });
          });
        }
      } else if (_inputShape != null &&
          _inputShape!.isNotEmpty &&
          _inputShape!.length == 2) {
        // Model expects a 1D vector input like [1, N]. Attempt to adapt the
        // image-derived flatInput to the expected length N by simple downsampling
        // or padding. This is a pragmatic fallback — for correct results the
        // model should be fed the same kind of features it was trained on
        // (e.g., keypoints). We log a warning so you can replace this with
        // a proper feature extractor if needed.
        final int expectedLen = _inputShape![1];
        final int actualLen = flatInput.length;
        if (expectedLen == actualLen) {
          nestedInput = [
            _inputIsUint8
                ? List<int>.from(flatInput.map((v) => (v * 255).toInt()))
                : flatInput,
          ];
        } else if (expectedLen < actualLen) {
          // Downsample by averaging blocks
          final Float32List reduced = Float32List(expectedLen);
          final double blockSize = actualLen / expectedLen;
          for (int i = 0; i < expectedLen; i++) {
            final int start = (i * blockSize).floor();
            final int end = ((i + 1) * blockSize).floor().clamp(0, actualLen);
            double sum = 0.0;
            int count = 0;
            for (int j = start; j < end; j++) {
              sum += flatInput[j];
              count++;
            }
            if (count == 0) count = 1;
            reduced[i] = (sum / count);
          }
          nestedInput = [
            _inputIsUint8
                ? List<int>.from(reduced.map((v) => (v * 255).toInt()))
                : reduced,
          ];
          print(
            'Warning: downsampled image vector $actualLen -> $expectedLen (temporary fallback)',
          );
        } else {
          // expectedLen > actualLen -> pad with zeros
          final Float32List padded = Float32List(expectedLen);
          for (int i = 0; i < actualLen; i++) padded[i] = flatInput[i];
          for (int i = actualLen; i < expectedLen; i++) padded[i] = 0.0;
          nestedInput = [
            _inputIsUint8
                ? List<int>.from(padded.map((v) => (v * 255).toInt()))
                : padded,
          ];
          print(
            'Warning: padded image vector $actualLen -> $expectedLen (temporary fallback)',
          );
        }
      } else {
        nestedInput = [
          _inputIsUint8
              ? List<int>.from(flatInput.map((v) => (v * 255).toInt()))
              : flatInput,
        ];
      }

      // Allocate output buffer according to model output shape
      dynamic outputBuf;
      if (_outputShape != null &&
          _outputShape!.isNotEmpty &&
          _outputShape!.length == 2) {
        outputBuf = List.generate(
          _outputShape![0],
          (_) => List.filled(_outputShape![1], 0.0),
        );
      } else if (_outputLen > 0) {
        outputBuf = List.filled(_outputLen, 0.0);
      } else {
        outputBuf = List.filled(labels.length, 0.0);
      }

      // Run inference
      if (_interpreter == null) {
        print('Interpreter is null during run; aborting inference.');
        return {'gesture': 'Error', 'confidence': 0.0, 'allScores': []};
      }
      _interpreter!.run(nestedInput, outputBuf);

      // Flatten output into a List<double> of scores
      List<double> scores;
      if (outputBuf is List && outputBuf.isNotEmpty && outputBuf[0] is List) {
        scores = List<double>.from(
          (outputBuf[0] as List).map((e) => (e as num).toDouble()),
        );
      } else if (outputBuf is List) {
        scores = List<double>.from(outputBuf.map((e) => (e as num).toDouble()));
      } else {
        scores = List.filled(labels.length, 0.0);
      }

      // Get the gesture with highest confidence
      int maxIndex = 0;
      double maxConfidence = scores.isNotEmpty ? scores[0] : 0.0;
      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > maxConfidence) {
          maxConfidence = scores[i];
          maxIndex = i;
        }
      }

      String predicted = labels.isNotEmpty && maxIndex < labels.length
          ? labels[maxIndex]
          : 'Unknown';

      // Apply confidence threshold
      if (maxConfidence < _minConfidence) {
        predicted = 'Unknown';
      }

      // Stability filter: require consecutive predictions
      if (predicted == _lastPredicted) {
        _consecutiveCount++;
      } else {
        _consecutiveCount = 1;
        _lastPredicted = predicted;
      }

      if (_consecutiveCount < _requiredConsecutive) {
        // Not stable yet
        return {
          'gesture': 'Skipped',
          'confidence': maxConfidence,
          'allScores': scores,
        };
      }

      return {
        'gesture': predicted,
        'confidence': maxConfidence,
        'allScores': scores,
      };
    } catch (e) {
      print('Error during inference: $e');
      return {'gesture': 'Error', 'confidence': 0.0, 'allScores': []};
    }
  }

  void _convertYUV420ToRGB(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final Uint8List yBytes = image.planes[0].bytes;
    final Uint8List uBytes = image.planes[1].bytes;
    final Uint8List vBytes = image.planes[2].bytes;

    // Initialize buffer if needed
    final expectedSize = width * height * 3;
    if (_imageBuffer.length != expectedSize) {
      _imageBuffer = List<int>.filled(expectedSize, 0);
    }

    int pixelIndex = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * width + x;
        final int uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

        final int yVal = yBytes[yIndex];
        final int uVal = uBytes[uvIndex];
        final int vVal = vBytes[uvIndex];

        // YUV to RGB conversion
        int r = ((yVal + (1.402 * (vVal - 128))).toInt()).clamp(0, 255);
        int g =
            ((yVal - (0.34414 * (uVal - 128)) - (0.71414 * (vVal - 128)))
                    .toInt())
                .clamp(0, 255);
        int b = ((yVal + (1.772 * (uVal - 128))).toInt()).clamp(0, 255);

        _imageBuffer[pixelIndex++] = r;
        _imageBuffer[pixelIndex++] = g;
        _imageBuffer[pixelIndex++] = b;
      }
    }
  }

  void dispose() {
    try {
      _interpreter?.close();
    } catch (_) {}
    _isInitialized = false;
  }
}
