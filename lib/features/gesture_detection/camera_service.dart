import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  late CameraController _cameraController;
  bool _isInitialized = false;
  bool _isFrontCamera = false;

  bool get isInitialized => _isInitialized;
  bool get isFrontCamera => _isFrontCamera;
  CameraController get controller => _cameraController;

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> initializeCamera() async {
    try {
      // Get available cameras
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use front camera for hand gesture detection
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset
            .medium, // Changed from high to medium for better performance
        enableAudio: false,
      );

      await _cameraController.initialize();
      _isInitialized = true;
      _isFrontCamera = frontCamera.lensDirection == CameraLensDirection.front;

      print('Camera initialized successfully');
    } catch (e) {
      print('Error initializing camera: $e');
      rethrow;
    }
  }

  Future<void> startImageStream(Function(CameraImage) onImageAvailable) async {
    if (!_isInitialized) {
      throw Exception('Camera not initialized. Call initializeCamera() first.');
    }

    try {
      await _cameraController.startImageStream(onImageAvailable);
    } catch (e) {
      print('Error starting image stream: $e');
      rethrow;
    }
  }

  Future<void> stopImageStream() async {
    if (_isInitialized && _cameraController.value.isStreamingImages) {
      try {
        await _cameraController.stopImageStream();
      } catch (e) {
        print('Error stopping image stream: $e');
      }
    }
  }

  Future<void> toggleCamera() async {
    if (!_isInitialized) return;

    try {
      await stopImageStream();

      final cameras = await availableCameras();
      final otherCamera = _isFrontCamera
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            )
          : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => cameras.first,
            );

      _cameraController.dispose();

      _cameraController = CameraController(
        otherCamera,
        ResolutionPreset
            .medium, // Changed from high to medium for better performance
        enableAudio: false,
      );

      await _cameraController.initialize();
      _isFrontCamera = otherCamera.lensDirection == CameraLensDirection.front;
    } catch (e) {
      print('Error toggling camera: $e');
    }
  }

  void dispose() {
    if (_isInitialized) {
      _cameraController.dispose();
      _isInitialized = false;
    }
  }
}
