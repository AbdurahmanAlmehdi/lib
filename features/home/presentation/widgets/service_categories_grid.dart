import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServiceCategoriesGrid extends StatelessWidget {
  final List<Service> services;
  final Function(Service)? onServiceTap;
  final bool isLoading;

  const ServiceCategoriesGrid({
    super.key,
    required this.services,
    this.onServiceTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    // if (services.isEmpty) {
    //   return const SizedBox.shrink();
    // }

    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: isLoading ? 4 : services.length,
          itemBuilder: (context, index) {
            final service = isLoading ? Service.empty : services[index];
            return _ServiceCard(
              service: service,
              locale: locale,
              onTap: () => onServiceTap?.call(service),
            );
          },
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final String locale;
  final VoidCallback? onTap;

  const _ServiceCard({required this.service, required this.locale, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: service.iconUrl.startsWith('assets/')
                  ? Image.asset(
                      service.iconUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 48,
                        height: 48,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.category),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: service.iconUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 48,
                        height: 48,
                        color: AppColors.surfaceVariant,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 48,
                        height: 48,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.category),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.getName(locale),
                style: AppTypography.titleMedium(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
