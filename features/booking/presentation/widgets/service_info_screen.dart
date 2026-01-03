import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            // Yellow background - full screen
            Container(
              color: AppColors.primary,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _BackButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
              ),
            ),
            // White card - positioned in center/lower part
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  final service = state.service;
                  if (service == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final locale = Localizations.localeOf(context).languageCode;
                  return _ServiceInfoCard(
                    serviceTitle: service.getName(locale),
                    serviceDescription:
                        service.getDescription(locale) ??
                        context.t.defaultServiceDescription,
                    serviceIconUrl: service.iconUrl,
                    onBookNow: () =>
                        context.pushNamed(AppRouteNames.dateTimeSelection),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
          size: 32,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _ServiceInfoCard extends StatelessWidget {
  final String serviceTitle;
  final String serviceDescription;
  final String serviceIconUrl;
  final VoidCallback onBookNow;

  const _ServiceInfoCard({
    required this.serviceTitle,
    required this.serviceDescription,
    required this.serviceIconUrl,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Service Icon - inside white card with shadow
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: serviceIconUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.primaryLight,
                      child: const Icon(
                        Icons.cleaning_services,
                        color: AppColors.primary,
                        size: 45,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primaryLight,
                      child: const Icon(
                        Icons.cleaning_services,
                        color: AppColors.primary,
                        size: 45,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Service Title
              Text(
                serviceTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineLarge(context).copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Service Description
              _DescriptionText(description: serviceDescription),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: AppColors.textOnSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: onBookNow,
                  child: Text(
                    context.t.bookNow,
                    style: AppTypography.titleLarge(context).copyWith(
                      color: AppColors.textOnSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  final String description;

  const _DescriptionText({required this.description});

  @override
  Widget build(BuildContext context) {
    // Split description into lines if it contains line breaks or is long
    final lines = description.split('\n');
    if (lines.length == 1 && description.length > 50) {
      // If single line is long, try to split by common separators
      final parts = description.split('،');
      return Column(
        children: parts.map((part) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              part.trim(),
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge(
                context,
              ).copyWith(color: AppColors.textSecondary, height: 1.6),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            line.trim(),
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge(
              context,
            ).copyWith(color: AppColors.textSecondary, height: 1.6),
          ),
        );
      }).toList(),
    );
  }
}
