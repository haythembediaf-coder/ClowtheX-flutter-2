import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';
import '../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeIn)),
    );

    _scaleIn = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOutBack)),
    );

    _controller.forward();

    // Navigate to home after splash
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ClowtheXApp(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Subtle gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Color(0xFF2A2A2A),
                      Color(0xFF0A0A0A),
                    ],
                  ),
                ),
              ),
              // Centered logo with animation
              Center(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: ScaleTransition(
                    scale: _scaleIn,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // The ClowtheX logo from assets
                        Image.asset(
                          'assets/images/splash_logo.png',
                          width: 280,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        // Loading indicator
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4A017),
                            strokeWidth: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
