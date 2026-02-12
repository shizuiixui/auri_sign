import 'package:flutter/material.dart';

/// Hand landmark indices for MediaPipe Hands (21 points)
/// 0: Wrist, 1-4: Thumb, 5-8: Index, 9-12: Middle, 13-16: Ring, 17-20: Pinky
class HandLandmarkPainter extends CustomPainter {
  final List<Offset> landmarks; // Normalized [0, 1] coordinates
  final Size previewSize;
  final Size imageSize;
  final bool isFrontCamera;
  final Color dotColor;
  final Color lineColor;
  final double dotRadius;

  HandLandmarkPainter({
    required this.landmarks,
    required this.previewSize,
    required this.imageSize,
    required this.isFrontCamera,
    this.dotColor = Colors.green,
    this.lineColor = Colors.cyan,
    this.dotRadius = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    final paint = Paint()
      ..color = dotColor
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Define connections between landmarks (hand skeletons)
    const connections = [
      // Thumb
      [0, 1], [1, 2], [2, 3], [3, 4],
      // Index
      [0, 5], [5, 6], [6, 7], [7, 8],
      // Middle
      [0, 9], [9, 10], [10, 11], [11, 12],
      // Ring
      [0, 13], [13, 14], [14, 15], [15, 16],
      // Pinky
      [0, 17], [17, 18], [18, 19], [19, 20],
      // Palm connections
      [5, 9], [9, 13], [13, 17],
    ];

    Offset toScreenSpace(Offset normalized) {
      double x = normalized.dx * size.width;
      double y = normalized.dy * size.height;

      if (isFrontCamera) {
        x = size.width - x;
      }

      return Offset(x, y);
    }

    // Convert all landmarks to screen space
    final screenLandmarks = landmarks
        .map((landmark) => toScreenSpace(landmark))
        .toList();

    // Draw lines (connections)
    for (final connection in connections) {
      final startIdx = connection[0];
      final endIdx = connection[1];
      if (startIdx < screenLandmarks.length &&
          endIdx < screenLandmarks.length) {
        canvas.drawLine(
          screenLandmarks[startIdx],
          screenLandmarks[endIdx],
          linePaint,
        );
      }
    }

    // Draw dots (landmarks)
    for (final landmark in screenLandmarks) {
      canvas.drawCircle(landmark, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(HandLandmarkPainter oldDelegate) {
    return landmarks != oldDelegate.landmarks;
  }
}
