import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/features/favorites/domain/entities/favorite_cleaner.dart';

class FavoriteCleanerCard extends StatelessWidget {
  final FavoriteCleaner favoriteCleaner;
  final VoidCallback? onTap;
  final VoidCallback? onUnfavoriteTap;

  const FavoriteCleanerCard({
    super.key,
    required this.favoriteCleaner,
    this.onTap,
    this.onUnfavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final cleaner = favoriteCleaner.cleaner;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cleaner.avatarUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 150,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.person, size: 48),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 150,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.person, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onUnfavoriteTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleaner.name,
                    style: AppTypography.titleMedium(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        cleaner.rating.toStringAsFixed(1),
                        style: AppTypography.bodySmall(
                          context,
                        ).copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${cleaner.reviewsCount})',
                        style: AppTypography.bodySmall(
                          context,
                        ).copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
