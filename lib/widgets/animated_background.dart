import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color dotColor;
  final int numberOfDots;

  const AnimatedBackground({
    Key? key,
    required this.child,
    this.dotColor = const Color(0xFF800000),
    this.numberOfDots = 40,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<FloatingDot> dots;
  late AnimationController _floatController;
  late AnimationController _pulseController;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    dots = List.generate(
      widget.numberOfDots,
      (index) => FloatingDot(
        x: random.nextDouble(),
        y: random.nextDouble(),
        baseSize: random.nextDouble() * 6 + 3,
        speedX: (random.nextDouble() - 0.5) * 0.0008,
        speedY: (random.nextDouble() - 0.5) * 0.0008,
        pulsePhase: random.nextDouble() * pi * 2,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _pulseController]),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);

            // Update dot positions
            for (var dot in dots) {
              dot.x += dot.speedX;
              dot.y += dot.speedY;

              // Gentle wrap around
              if (dot.x < -0.1) dot.x = 1.1;
              if (dot.x > 1.1) dot.x = -0.1;
              if (dot.y < -0.1) dot.y = 1.1;
              if (dot.y > 1.1) dot.y = -0.1;
            }

            return Stack(
              children: [
                // Elegant gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        const Color(0xFFFAFAFA),
                        const Color(0xFFF5F0F0),
                      ],
                    ),
                  ),
                ),

                // Floating dots layer
                CustomPaint(
                  size: size,
                  painter: FloatingDotsPainter(
                    dots: dots,
                    canvasSize: size,
                    dotColor: widget.dotColor,
                    pulseValue: _pulseController.value,
                  ),
                ),

                // Content
                widget.child,
              ],
            );
          },
        );
      },
    );
  }
}

class FloatingDot {
  double x, y;
  double baseSize;
  double speedX, speedY;
  double pulsePhase;

  FloatingDot({
    required this.x,
    required this.y,
    required this.baseSize,
    required this.speedX,
    required this.speedY,
    required this.pulsePhase,
  });
}

class FloatingDotsPainter extends CustomPainter {
  final List<FloatingDot> dots;
  final Size canvasSize;
  final Color dotColor;
  final double pulseValue;

  FloatingDotsPainter({
    required this.dots,
    required this.canvasSize,
    required this.dotColor,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var dot in dots) {
      final center = Offset(
        dot.x * canvasSize.width,
        dot.y * canvasSize.height,
      );

      // Calculate pulsing size
      final pulse = sin(pulseValue * pi * 2 + dot.pulsePhase);
      final currentSize = dot.baseSize * (0.7 + pulse * 0.3);
      final opacity = 0.15 + pulse * 0.1;

      // Draw soft outer glow
      final glowPaint = Paint()
        ..color = dotColor.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(center, currentSize * 3, glowPaint);

      // Draw middle glow
      final middlePaint = Paint()
        ..color = dotColor.withOpacity(opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(center, currentSize * 1.5, middlePaint);

      // Draw solid inner dot
      final dotPaint = Paint()
        ..color = dotColor.withOpacity(opacity + 0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, currentSize, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
