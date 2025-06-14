import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedPricePopped extends StatelessWidget {
  final double price;
  final TextStyle? style;
  final Duration duration;

  const AnimatedPricePopped({
    super.key,
    required this.price,
    this.style,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut))
            .animate(animation);

        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        key: ValueKey(price),
        style: style ??
            GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
      ),
    );
  }
}
