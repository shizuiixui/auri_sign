import 'package:camera/camera.dart';
// import 'package:hand_landmarker/hand_landmarker.dart';
// NOTE: This service uses hand_landmarker package which is not in pubspec.yaml
// The active gesture detection uses gesture_detector.dart instead

// Mock implementation - kept for backward compatibility only
// Use gesture_detector.dart instead for active gesture detection
class HandDetectorService {
  // Dynamic? _plugin;
  bool _isInitialized = false;

  /// Hand landmarks (21 points × 3 coords = 63 values)
  List<double> _lastLandmarks = [];

  /// Get the last detected hand landmarks
  List<double> get lastLandmarks => _lastLandmarks;

  /// Whether a hand was detected in the last frame
  bool _handDetected = false;
  bool get handDetected => _handDetected;

  /// Camera description (needed for sensor orientation)
  CameraDescription? _cameraDescription;

  /// Initialize the hand detector
  Future<void> initialize({CameraDescription? cameraDescription}) async {
    try {
      _cameraDescription = cameraDescription;
      // _plugin = HandLandmarkerPlugin.create(
      //   numHands: 1,
      //   minHandDetectionConfidence: 0.5,
      //   delegate: HandLandmarkerDelegate.gpu,
      // );
      _isInitialized = true;
      print('Hand detector initialized (mock - not functional)');
    } catch (e) {
      print('Error initializing hand detector: $e');
      _isInitialized = false;
    }
  }

  /// Set camera description (needed for sensor orientation)
  void setCameraDescription(CameraDescription description) {
    _cameraDescription = description;
  }

  /// Process a camera image and detect hand landmarks
  /// Returns true if hand was detected
  Future<bool> detectHand(CameraImage image) async {
    if (!_isInitialized || _cameraDescription == null) {
      return false;
    }

    try {
      // Mock implementation - always returns false
      _handDetected = false;
      _lastLandmarks.clear();
      return false;
    } catch (e) {
      print('Error detecting hand: $e');
      _handDetected = false;
      _lastLandmarks.clear();
      return false;
    }
  }

  /// Extract landmarks and normalize to [0, 1]
  // void _extractLandmarks(List<dynamic> landmarks) {
  //   final List<double> result = [];
  //
  //   // Each landmark has x, y, z coordinates
  //   // Store them in a flat list: [x0, y0, z0, x1, y1, z1, ...]
  //   // for (final landmark in landmarks) {
  //   //   result.add(landmark.x.clamp(0.0, 1.0));
  //   //   result.add(landmark.y.clamp(0.0, 1.0));
  //   //   result.add(landmark.z.clamp(-1.0, 1.0));
  //   // }
  //
  //   // Ensure we have exactly 63 values (21 landmarks × 3 coords)
  //   while (result.length < 63) {
  //     result.add(0.0);
  //   }
  //   if (result.length > 63) {
  //     result.removeRange(63, result.length);
  //   }
  //
  //   _lastLandmarks = result;
  // }

  /// Dispose of resources
  void dispose() {
    try {
      // _plugin?.dispose();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing hand detector: $e');
    }
  }

  /// Close the hand detector (alias for dispose)
  void close() {
    dispose();
  }
}
