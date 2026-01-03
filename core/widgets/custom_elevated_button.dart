import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isOutlined;
  final bool isLoading;
  final double height;
  final double maxWidth;
  final bool hideGradient;
  final double? width;
  final Color? buttonColor;
  final bool isBoldText;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool iconAfterText;
  final double iconSpacing;
  final BuildContext? context;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.isLoading,
    this.isOutlined = false,
    required this.buttonText,
    this.hideGradient = false,
    this.isBoldText = true,
    this.buttonColor = AppColors.secondary,
    this.height = 56,
    this.width = double.infinity,
    this.maxWidth = double.infinity,
    this.textStyle,
    this.foregroundColor = AppColors.textOnSecondary,
    this.icon,
    this.iconAfterText = true,
    this.iconSpacing = 8.0,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    final ctx = this.context ?? context;
    final isDark = Theme.of(ctx).brightness == Brightness.dark;

    return Container(
      height: height,
      width: width,
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: isOutlined
          ? BoxDecoration(
              gradient: hideGradient
                  ? null
                  : LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              color: hideGradient ? buttonColor : null,
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              gradient: hideGradient
                  ? null
                  : LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              color: hideGradient ? buttonColor : null,
              boxShadow: hideGradient
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
              borderRadius: BorderRadius.circular(12),
            ),
      child: isOutlined
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildButtonContent(ctx),
              ),
            )
          : _buildButtonContent(ctx),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isOutlined ? 10 : 12),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? LoadingIndicator(
              color: foregroundColor ?? AppColors.textOnSecondary,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null && !iconAfterText) ...[
                  icon!,
                  SizedBox(width: iconSpacing),
                ],
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style:
                      textStyle ??
                      AppTypography.titleMedium(context).copyWith(
                        color: isOutlined
                            ? AppColors.primary
                            : foregroundColor ?? AppColors.textOnSecondary,
                        fontWeight: isBoldText
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                ),
                if (icon != null && iconAfterText) ...[
                  SizedBox(width: iconSpacing),
                  icon!,
                ],
              ],
            ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(color: color, size: 18.0);
  }
}
