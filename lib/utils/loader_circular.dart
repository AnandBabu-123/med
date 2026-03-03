import 'package:flutter/material.dart';
import 'dart:math';


class CircularLineLoader extends StatefulWidget {
  const CircularLineLoader({super.key});

  @override
  State<CircularLineLoader> createState() => _CircularLineLoaderState();
}

class _CircularLineLoaderState extends State<CircularLineLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: SizedBox(
          height: 50,
          width: 50,
          child: CustomPaint(
            painter: _LinePainter(),
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int lines = 12;

    for (int i = 0; i < lines; i++) {
      final angle = (2 * pi / lines) * i;

      final start = Offset(
        center.dx + (radius - 12) * cos(angle),
        center.dy + (radius - 12) * sin(angle),
      );

      final end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      paint.color = Colors.blue.withOpacity((i + 1) / lines);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}