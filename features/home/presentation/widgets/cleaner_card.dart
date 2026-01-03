import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';

class CleanerCard extends StatelessWidget {
  final Cleaner cleaner;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const CleanerCard({
    super.key,
    required this.cleaner,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Avatar(avatarUrl: cleaner.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleaner.name,
                      style: AppTypography.titleLarge(context),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          cleaner.rating.toStringAsFixed(1),
                          style: AppTypography.number(context, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
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
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String avatarUrl;

  const _Avatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 64,
          height: 64,
          color: AppColors.surfaceVariant,
          child: const Icon(Icons.person),
        ),
        errorWidget: (context, url, error) => Container(
          width: 64,
          height: 64,
          color: AppColors.surfaceVariant,
          child: const Icon(Icons.person),
        ),
      ),
    );
  }
}
