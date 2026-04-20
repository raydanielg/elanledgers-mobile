import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Main image area with floating icons
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Floating icons around the image
                // Plus icon - left
                Positioned(
                  top: 60,
                  left: 10,
                  child: Icon(
                    Icons.add,
                    color: Colors.pink.shade200,
                    size: 28,
                  ),
                ),

                // Green dot - top left
                Positioned(
                  top: 100,
                  left: 50,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Heart icon - top right
                Positioned(
                  top: 80,
                  right: 30,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red.shade300,
                    size: 24,
                  ),
                ),

                // Shopping cart with checkmark - left
                Positioned(
                  bottom: 120,
                  left: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1565C0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Discount tag - right side
                Positioned(
                  top: 140,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.orange.shade600,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '%',
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bookmark - bottom right
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: Icon(
                    Icons.bookmark_outline,
                    color: const Color(0xFF1565C0).withOpacity(0.4),
                    size: 26,
                  ),
                ),

                // Chat bubble - bottom
                Positioned(
                  bottom: 140,
                  left: 60,
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: const Color(0xFF1565C0).withOpacity(0.4),
                    size: 20,
                  ),
                ),

                // Heart - bottom
                Positioned(
                  bottom: 80,
                  left: 80,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pink.shade200,
                    size: 20,
                  ),
                ),

                // Main image with rounded frame
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF1565C0).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      data.image,
                      fit: BoxFit.contain,
                      height: 280,
                      width: 240,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 280,
                          width: 240,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
