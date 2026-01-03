import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class LineThroughHeader extends StatelessWidget {
  final String text;
  const LineThroughHeader({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(width: 20, height: 1, color: AppColors.divider),
          Text(text, style: AppTypography.headlineMedium(context)),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: AppColors.divider)),
        ],
      ),
    );
  }
}
