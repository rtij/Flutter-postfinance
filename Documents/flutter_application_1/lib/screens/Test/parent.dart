import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/themeProvider.dart';
import 'child.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String messageFromChild = "Nothing";

  void handleMessage(String message) {
    setState(() {
      messageFromChild = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1a1a2e),
                        const Color(0xFF16213e),
                        const Color(0xFF0f3460),
                      ]
                    : [
                        const Color(0xFF667eea),
                        const Color(0xFF764ba2),
                        const Color(0xFFf093fb),
                      ],
              ),
            ),
          ),

          // Decorative Shapes
          Positioned.fill(
            child: CustomPaint(
              painter: ShapesPainter(isDark: isDark),
            ),
          ),

          // Blur Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header with theme toggle
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.white,
                        ),
                      ),
                      // Theme Toggle Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Area with Glassmorphism
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flutter_dash,
                                size: 80,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Flutter Blur Effect',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'with Gradient Background',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 30),
                              EnfantWidget(onMessageSent: handleMessage),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  messageFromChild,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Decorative Shapes
class ShapesPainter extends CustomPainter {
  final bool isDark;

  ShapesPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.white.withOpacity(0.15);

    // Draw circles
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.15), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.25), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.75), 50, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.8), 35, paint);

    // Draw squares
    final squarePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.white.withOpacity(0.03)
          : Colors.white.withOpacity(0.1);

    canvas.save();
    canvas.translate(size.width * 0.8, size.height * 0.1);
    canvas.rotate(0.5);
    canvas.drawRect(const Rect.fromLTWH(-25, -25, 50, 50), squarePaint);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width * 0.15, size.height * 0.5);
    canvas.rotate(-0.3);
    canvas.drawRect(const Rect.fromLTWH(-30, -30, 60, 60), squarePaint);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width * 0.75, size.height * 0.65);
    canvas.rotate(0.8);
    canvas.drawRect(const Rect.fromLTWH(-20, -20, 40, 40), squarePaint);
    canvas.restore();

    // Draw small circles scattered
    final smallCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.white.withOpacity(0.04)
          : Colors.white.withOpacity(0.12);

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.2), 15, smallCirclePaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 20, smallCirclePaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.85), 18, smallCirclePaint);
    canvas.drawCircle(Offset(size.width * 0.95, size.height * 0.5), 12, smallCirclePaint);
  }

  @override
  bool shouldRepaint(ShapesPainter oldDelegate) => oldDelegate.isDark != isDark;
}