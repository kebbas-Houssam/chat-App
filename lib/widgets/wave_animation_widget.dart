import 'dart:math';
import 'package:flutter/material.dart';

class MovingSoundWaves extends StatefulWidget {
  final Color waveColor;
  final double height;
  final double width; // New parameter for animation width

  const MovingSoundWaves({
    Key? key,
    required this.waveColor,
    required this.height,
    required this.width, // Default width of 120px
  }) : super(key: key);

  @override
  _MovingSoundWavesState createState() => _MovingSoundWavesState();
}

class _MovingSoundWavesState extends State<MovingSoundWaves> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SoundWavePainter(
              animation: _controller,
              waveColor: widget.waveColor,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

class SoundWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;

  SoundWavePainter({required this.animation, required this.waveColor})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final random = Random(30);
    final barCount = size.width ~/ 3;
    final moveOffset = animation.value * size.width;

    for (int i = 0; i < barCount; i++) {
      final x = (i * 3.0 + moveOffset) % size.width;

      final normalizedX = x / size.width;
      final sinValue = sin((normalizedX * 20 + animation.value * 2) * 2 * pi);

      final randomHeight = random.nextDouble() * size.height * 0.6;
      final barHeight = (randomHeight + sinValue * 10).clamp(5, size.height);

      final startY = size.height / 2 - barHeight / 2;
      final endY = startY + barHeight;

      final opacity = (1.5 - (x / size.width)).clamp(0.2, 1.0);
      paint.color = waveColor.withOpacity(opacity);

      canvas.drawLine(
          Offset(size.width - x, startY), Offset(size.width - x, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SoundWavePainter oldDelegate) => true;
}
