import 'package:flutter/material.dart';
import '../../core/app_constants.dart';

class SideActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SideActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 36, color: color, shadows: const [
            Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))
          ]),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}