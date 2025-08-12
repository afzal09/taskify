import 'package:flutter/material.dart';
import 'package:whatbytes_assignment/features/auth/presentation/screens/sign_up.dart';
import 'package:whatbytes_assignment/src/theme/theme_values.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background purple elements
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A5AE0),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.whiteColor,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Get things done.',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkgreyColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Just a click away from\nplanning your tasks',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: index == 0 ? 24 : 8, // First dot is longer
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == 0 ? const Color(0xFF6A5AE0) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      color: const Color(0xFF6A5AE0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the bottom wave shape
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.6); // Start point
    path.quadraticBezierTo(
      size.width / 4, size.height,
      size.width / 2, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4, size.height * 0.2,
      size.width, size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}