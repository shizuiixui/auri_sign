import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:auri_sign/features/gesture_detection/gesture_detector.dart'
    as gd;
import 'package:auri_sign/features/gesture_detection/camera_service.dart';
import 'package:auri_sign/features/gesture_detection/fsl_mapper.dart';

class GestureDetectionScreen extends StatefulWidget {
  const GestureDetectionScreen({Key? key}) : super(key: key);

  @override
  State<GestureDetectionScreen> createState() => _GestureDetectionScreenState();
}

class _GestureDetectionScreenState extends State<GestureDetectionScreen>
    with WidgetsBindingObserver {
  late CameraService _cameraService;
  late gd.GestureDetector _gestureDetector;

  String _detectedGesture = 'Initializing...';
  double _confidence = 0.0;
  String _confidenceLevel = '';
  List<String> _gestureHistory = [];
  String _translatedText = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _cameraService = CameraService();
    _gestureDetector = gd.GestureDetector();

    try {
      // Request camera permission
      final hasPermission = await _cameraService.requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _detectedGesture = 'Camera permission denied';
        });
        return;
      }

      // Initialize camera
      await _cameraService.initializeCamera();

      // Load the TFLite model
      await _gestureDetector.loadModel();

      // Start image stream
      await _cameraService.startImageStream(_processImage);

      setState(() {
        _detectedGesture = 'Ready to detect gestures';
      });
    } catch (e) {
      setState(() {
        _detectedGesture = 'Error: ${e.toString()}';
      });
      print('Initialization error: $e');
    }
  }

  void _processImage(CameraImage image) async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      final result = await _gestureDetector.runInference(image);

      // Skip skipped frames
      if (result['gesture'] == 'Skipped') {
        _isProcessing = false;
        return;
      }

      if (mounted) {
        setState(() {
          _detectedGesture = result['gesture'] ?? 'Unknown';
          _confidence = result['confidence'] ?? 0.0;
          _confidenceLevel = FSLMapper.getConfidenceDescription(_confidence);

          // Only add to history if confidence is high enough
          if (_confidence > 0.6 && _detectedGesture != 'Unknown') {
            if (_gestureHistory.isEmpty ||
                _gestureHistory.last != _detectedGesture) {
              _gestureHistory.add(_detectedGesture);
              _translatedText = FSLMapper.buildText(_gestureHistory);
            }
          }
        });
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _clearHistory() {
    setState(() {
      _gestureHistory.clear();
      _translatedText = '';
    });
  }

  void _undoLastGesture() {
    if (_gestureHistory.isNotEmpty) {
      setState(() {
        _gestureHistory.removeLast();
        _translatedText = FSLMapper.buildText(_gestureHistory);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraService.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraService.stopImageStream();
    } else if (state == AppLifecycleState.resumed) {
      _cameraService.startImageStream(_processImage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.stopImageStream();
    _cameraService.dispose();
    _gestureDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Gesture Detection'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _cameraService.isInitialized
          ? Column(
              children: [
                // Camera Preview
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_cameraService.controller),
                        // Gesture overlay
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _confidence > 0.7
                                    ? Colors.green
                                    : Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Detected Gesture',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[400]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _detectedGesture,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Confidence:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[400]),
                                    ),
                                    Text(
                                      '${(_confidence * 100).toStringAsFixed(1)}% ($_confidenceLevel)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gesture History and Translation
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detected Sequence',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  _translatedText.isEmpty
                                      ? 'Perform gestures to build text...'
                                      : _translatedText,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'History: ${_gestureHistory.join(", ")}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Control Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _undoLastGesture,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _clearHistory,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Copy to clipboard functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied: $_translatedText'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _detectedGesture,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
    );
  }
}
