import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class HomeAppBar extends StatelessWidget {
  static const double height = 180;
  final String? currentLocation;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLocationTap;

  const HomeAppBar({
    super.key,
    this.currentLocation,
    this.onSearchTap,
    this.onNotificationTap,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _SearchBar(onTap: onSearchTap)),
              const SizedBox(width: 12),
              _NotificationButton(onTap: onNotificationTap),
            ],
          ),
          const SizedBox(height: 12),
          _LocationIndicator(
            location: currentLocation ?? 'Current Location',
            onTap: onLocationTap,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const _SearchBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.t.search,
                style: AppTypography.bodyMedium(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _NotificationButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.notifications_outlined,
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}

class _LocationIndicator extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const _LocationIndicator({required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: AppTypography.bodyMedium(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
