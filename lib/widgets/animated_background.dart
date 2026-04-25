import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color dotColor;
  final Color lineColor;
  final int numberOfDots;

  const AnimatedBackground({
    Key? key,
    required this.child,
    this.dotColor = const Color(0xFF800000),
    this.lineColor = const Color(0xFF800000),
    this.numberOfDots = 50,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    particles = List.generate(
      widget.numberOfDots,
      (index) => Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: (random.nextDouble() - 0.5) * 0.002,
        vy: (random.nextDouble() - 0.5) * 0.002,
        size: random.nextDouble() * 4 + 2,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateParticles(Size size) {
    for (var particle in particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;

      // Bounce off edges
      if (particle.x <= 0 || particle.x >= 1) {
        particle.vx *= -1;
        particle.x = particle.x.clamp(0.0, 1.0);
      }
      if (particle.y <= 0 || particle.y >= 1) {
        particle.vy *= -1;
        particle.y = particle.y.clamp(0.0, 1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            updateParticles(Size(constraints.maxWidth, constraints.maxHeight));
            return Stack(
              children: [
                // White base background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        const Color(0xFFFDF8F8),
                        const Color(0xFFF5E6E6).withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // CustomPaint for dots and lines
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ParticlePainter(
                    particles: particles,
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    dotColor: widget.dotColor,
                    lineColor: widget.lineColor.withOpacity(0.15),
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

class Particle {
  double x, y;
  double vx, vy;
  double size;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Size size;
  final Color dotColor;
  final Color lineColor;

  ParticlePainter({
    required this.particles,
    required this.size,
    required this.dotColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final dotPaint = Paint()
      ..color = dotColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Draw connections between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.3;
          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint..color = lineColor.withOpacity(opacity),
          );
        }
      }
    }

    // Draw particles
    for (var particle in particles) {
      final center = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Outer glow
      canvas.drawCircle(
        center,
        particle.size * 2,
        Paint()
          ..color = dotColor.withOpacity(0.1)
          ..style = PaintingStyle.fill,
      );

      // Inner dot
      canvas.drawCircle(
        center,
        particle.size,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
