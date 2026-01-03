import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String dateTime;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.headlineSmall(
                    context,
                  ).copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dateTime,
                    style: AppTypography.labelSmall(
                      context,
                    ).copyWith(color: AppColors.textDisabled),
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
