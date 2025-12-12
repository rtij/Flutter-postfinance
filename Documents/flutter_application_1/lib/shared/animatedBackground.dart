import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/themeProvider.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget content;
  const AnimatedBackground({super.key, required this.content});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {

  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: Listenable.merge([_controller1, _controller2, _controller3]),
            builder: (context, child) {
              return Container(
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
                            const Color(0xFFe0c3fc),
                            const Color(0xFFf3e7e9),
                            const Color(0xFFfbc2eb),
                          ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Gradient Orb 1
                    Positioned(
                      top: 100 + (_controller1.value * 50),
                      left: 50 + (_controller1.value * 30),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: isDark
                                ? [
                                    Theme.of(context).primaryColor.withOpacity(0.3),
                                    const Color(0xFF8b5cf6).withOpacity(0.1),
                                  ]
                                : [
                                    const Color(0xFFa855f7).withOpacity(0.3),
                                    Theme.of(context).primaryColor.withOpacity(0.3).withOpacity(0.1),
                                  ],
                          ),
                        ),
                      ),
                    ),
                    // Gradient Orb 2
                    Positioned(
                      top: 150 + (_controller2.value * 40),
                      right: 50 + (_controller2.value * 40),
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF8b5cf6).withOpacity(0.3),
                                    const Color(0xFFec4899).withOpacity(0.1),
                                  ]
                                : [
                                    const Color(0xFFec4899).withOpacity(0.3),
                                    const Color(0xFFa855f7).withOpacity(0.1),
                                  ],
                          ),
                        ),
                      ),
                    ),
                    // Gradient Orb 3
                    Positioned(
                      bottom: 100 + (_controller3.value * 60),
                      left: MediaQuery.of(context).size.width * 0.3 + (_controller3.value * 20),
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF3b82f6).withOpacity(0.3),
                                    Theme.of(context).primaryColor.withOpacity(0.3).withOpacity(0.1),
                                  ]
                                : [
                                    Theme.of(context).primaryColor.withOpacity(0.3).withOpacity(0.3),
                                    const Color(0xFF3b82f6).withOpacity(0.1),
                                  ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Login Card with Theme Switcher
          SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Login Card
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.1 : 0.7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: widget.content,
                      ),
                    ),
                  ),
                ),
                
                // Theme Switcher positioned on top of the card
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.1 : 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return Icon(
                            themeProvider.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.nightlight_round,
                            color: isDark ? Colors.white : Theme.of(context).primaryColor,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Page Indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366f1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
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

