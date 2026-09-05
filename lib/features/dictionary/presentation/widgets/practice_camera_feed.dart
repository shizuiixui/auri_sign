import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PracticeCameraFeed extends StatefulWidget {
  const PracticeCameraFeed({super.key});

  @override
  State<PracticeCameraFeed> createState() => _PracticeCameraFeedState();
}

class _PracticeCameraFeedState extends State<PracticeCameraFeed>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraActive = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Camera permission is required to practice.';
          });
        }
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No camera found on this device.';
          });
        }
        return;
      }

      // Use front camera
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      await _cameraController?.dispose();
      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (mounted) {
        setState(() {
          _cameraController = controller;
          _isCameraActive = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not start camera: $e';
        });
      }
    }
  }

  Future<void> _stopCamera() async {
    await _cameraController?.dispose();
    if (mounted) {
      setState(() {
        _cameraController = null;
        _isCameraActive = false;
        _isLoading = false;
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(
              Icons.videocam_rounded,
              size: 20,
              color: Color(0xFF334155),
            ),
            const SizedBox(width: 8),
            Text(
              "Your Practice Feed",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Main Feed Container
        _isCameraActive &&
                _cameraController != null &&
                _cameraController!.value.isInitialized
            ? _buildActiveCameraView()
            : _buildInactivePlaceholder(),
      ],
    );
  }

  Widget _buildActiveCameraView() {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Camera Preview with Aspect Ratio
            AspectRatio(
              aspectRatio: 16 / 9,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width:
                      _cameraController!.value.previewSize?.height ?? size.width,
                  height: _cameraController!.value.previewSize?.width ??
                      size.width * (9 / 16),
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

            // Top-right Close Button
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 20),
                  tooltip: "Close Camera",
                  onPressed: _stopCamera,
                ),
              ),
            ),

            // Bottom Stop Camera Pill Button
            Positioned(
              bottom: 10,
              child: GestureDetector(
                onTap: _stopCamera,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stop_circle_rounded,
                          color: Colors.redAccent, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Stop Camera",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_isLoading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFB800)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInactivePlaceholder() {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xFFCBD5E1),
        strokeWidth: 1.5,
        dash: 6,
        gap: 4,
        radius: 16,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(color: Color(0xFFFFB800)),
              const SizedBox(height: 12),
              Text(
                "Starting camera...",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
            ] else if (_errorMessage != null) ...[
              const Icon(
                Icons.videocam_off_outlined,
                size: 38,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _startCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ] else ...[
              // Camera Icon
              Icon(
                Icons.camera_alt_rounded,
                size: 38,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                "Enable Camera to Practice",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                "Turn on your camera to compare your sign in real-time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: 'Poppins',
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),

              // Start Camera Button
              ElevatedButton.icon(
                onPressed: _startCamera,
                icon: const Icon(
                  Icons.videocam_rounded,
                  color: Colors.black,
                  size: 18,
                ),
                label: const Text(
                  "Start Camera",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shadowColor: const Color(0xFFFFB800).withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dash = 6,
    this.gap = 4,
    this.radius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dash > metric.length)
            ? metric.length - distance
            : dash;
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}
