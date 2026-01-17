import 'package:flutter/material.dart';
import '../../core/app_constants.dart';


class ARButton extends StatelessWidget {
  final VoidCallback onAction;

  const ARButton({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.teal.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: onAction,
              child: const Icon(Icons.view_in_ar, color: AppColors.white, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          AppStrings.staging,
          style: TextStyle(color: AppColors.teal, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}