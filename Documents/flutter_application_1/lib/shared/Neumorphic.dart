import 'package:flutter/material.dart';
class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isPressed;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF3A3D40) : const Color.fromARGB(255, 238, 245, 255);
    final shadowColor = isDark ? Colors.black54 : Colors.black12;
    final lightShadowColor = isDark ? const Color.fromARGB(255, 48, 52, 56) : const Color.fromARGB(255, 238, 238, 238);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: lightShadowColor,
                  offset: const Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: lightShadowColor,
                  offset: const Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: child,
    );
  }
}
