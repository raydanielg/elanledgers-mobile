import 'package:flutter/material.dart';

class ImageBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final double opacity;

  const ImageBackground({
    Key? key,
    required this.child,
    this.imagePath = 'lib/images/flat-wavy-organic-abstract-background-pattern-vector_1091888-444.jpg',
    this.opacity = 0.4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image - Visible but subtle
        Opacity(
          opacity: 0.18,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              // If image fails to load, show gradient background instead
              return Container(
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
              );
            },
          ),
        ),
        // No overlay needed - image is already very subtle
        Container(
          color: Colors.transparent,
        ),
        // Content
        child,
      ],
    );
  }
}
