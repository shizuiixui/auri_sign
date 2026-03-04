import 'package:camera/camera.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

class HandLandmarkerService {
  HandLandmarkerPlugin? _landmarker;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _landmarker = HandLandmarkerPlugin.create();
    _isInitialized = true;
  }

  Future<List<Hand>> detectHands(
    CameraImage image,
    int sensorOrientation,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }
    if (_landmarker == null) return [];
    return _landmarker!.detect(image, sensorOrientation);
  }

  void dispose() {
    try {
      _landmarker?.dispose();
    } catch (_) {}
    _landmarker = null;
    _isInitialized = false;
  }
}
