import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20),

        decoration: BoxDecoration(
          color: const Color(0xfff6f6f6),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 30),

            const SizedBox(height: 10),

            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
