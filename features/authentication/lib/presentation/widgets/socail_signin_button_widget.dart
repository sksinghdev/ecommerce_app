import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed; // <- Add this

  const SocialSignInButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed, // <- Make it required
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: onPressed, // <- Use the callback here
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
