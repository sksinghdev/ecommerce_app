import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() onPressed;
  final Color color;

  const AnimatedActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = Colors.deepPurple,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  bool _isProcessing = false;
  bool _showIcon = false;

  Future<void> _handleTap() async {
    setState(() {
      _isProcessing = true;
    });

    await widget.onPressed();

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showIcon = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isProcessing = false;
      _showIcon = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _isProcessing ? 56 : 180,
      height: 45,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : _handleTap,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isProcessing
                  ? _showIcon
                      ? Icon(widget.icon,
                          color: Colors.white, key: const ValueKey('icon'))
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                            key: ValueKey('loader'),
                          ),
                        )
                  : Text(
                      widget.label,
                      key: const ValueKey('text'),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
