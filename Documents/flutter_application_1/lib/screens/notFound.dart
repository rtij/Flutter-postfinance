import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import '../../providers/themeProvider.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _floatController;

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
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _floatController.dispose();
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
            animation:
                Listenable.merge([_controller1, _controller2, _controller3]),
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
                                    const Color(0xFF6366f1).withOpacity(0.3),
                                    const Color(0xFF8b5cf6).withOpacity(0.1),
                                  ]
                                : [
                                    const Color(0xFFa855f7).withOpacity(0.3),
                                    const Color(0xFF6366f1).withOpacity(0.1),
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
                      left: MediaQuery.of(context).size.width * 0.3 +
                          (_controller3.value * 20),
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF3b82f6).withOpacity(0.3),
                                    const Color(0xFF6366f1).withOpacity(0.1),
                                  ]
                                : [
                                    const Color(0xFF6366f1).withOpacity(0.3),
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

          // Main Card - Full Page
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.7),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Animated 404 Icon
                                AnimatedBuilder(
                                  animation: _floatController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                          0, -10 + (_floatController.value * 20)),
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF6366f1),
                                          Color(0xFF8b5cf6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6366f1)
                                              .withOpacity(0.4),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.error_outline,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // 404 Text
                                Text(
                                  '404',
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFF6366f1),
                                          Color(0xFF8b5cf6),
                                          Color(0xFFec4899),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0, 0, 400, 120),
                                      ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title
                                Text(
                                  'Page introuvable',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1f2937),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Description
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    'Oups! La page que vous recherchez semble s\'être perdue dans l\'espace numérique.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                      color: isDark
                                          ? Colors.white.withOpacity(0.7)
                                          : const Color(0xFF6b7280),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 48),

                                // Action Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Back to Login Button
                                    ElevatedButton(
                                      onPressed: () {
                                        Beamer.of(context).beamToNamed('/login');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF6366f1),
                                              Color(0xFF8b5cf6),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6366f1)
                                                  .withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 16,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.home,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Retour à l\'accueil',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Go Back Button
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Beamer.of(context).beamToNamed('/login');
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        size: 16,
                                        color: isDark
                                            ? const Color(0xFF818cf8)
                                            : const Color(0xFF6366f1),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Retour en arrière',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? const Color(0xFF818cf8)
                                              : const Color(0xFF6366f1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Fun illustration text
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.05)
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '🔍',
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          'Astuce: Vérifiez l\'URL ou utilisez le menu de navigation',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white.withOpacity(0.6)
                                                : const Color(0xFF6b7280),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Theme Switcher
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
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
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF6366f1),
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
          ),
        ],
      ),
    );
  }
}