import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 16,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            context.t.aboutTheApp,
            style: AppTypography.headlineSmall(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
              child: Image.asset(
                'assets/images/appLogo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            const SizedBox(height: 4),

            // App Description
            Text(
              _getAppDescription(context),
              style: AppTypography.bodyLarge(
                context,
              ).copyWith(color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Version Info
            _InfoRow(label: _getVersionLabel(context), value: '1.0.0'),
            const SizedBox(height: 16),
            _InfoRow(label: _getBuildNumberLabel(context), value: '1'),
            const SizedBox(height: 32),

            // Additional Information
            // Additional Information
            Center(
              child: Directionality(
                textDirection:
                    Localizations.localeOf(context).languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Text(
                  _getAdditionalInfo(context),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppDescription(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ar') {
      return 'تطبيق متخصص في خدمات التنظيف المنزلي والمكتبي. نوفر لك أفضل الخدمات مع فريق محترف من عمال النظافة.';
    }
    return 'A specialized app for home and office cleaning services. We provide you with the best services with a professional team of cleaners.';
  }

  String _getAdditionalInfo(BuildContext context) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  if (isArabic) {
    // isolate the LTR segment inside Arabic text
    const ltrIsolateStart = '\u2066'; // LRI
    const isolateEnd = '\u2069';      // PDI

    return 'جميع الحقوق محفوظة. $ltrIsolateStart© 2025 Buzzy Bee$isolateEnd';
  }

  return '© 2025 Buzzy Bee. All rights reserved.';
}

  String _getVersionLabel(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? 'الإصدار' : 'Version';
  }

  String _getBuildNumberLabel(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? 'رقم البناء' : 'Build Number';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
