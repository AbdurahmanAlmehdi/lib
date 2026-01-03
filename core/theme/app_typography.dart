import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTypography {
  AppTypography._();


  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      height: 1.1,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
      height: 1.2,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.3,
    );
  }


  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      height: 1.4,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    );
  }


  static TextStyle headlineSmall(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.4,
    );
  }

  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    );
  }


  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.5,
    );
  }
  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.5,
    );
  }


  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.tajawal(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }


  static TextStyle number(BuildContext context, {double? fontSize}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.5,
    );
  }

  static TextStyle numberLarge(BuildContext context) {
    return GoogleFonts.jetBrainsMono(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    );
  }

  static TextStyle numberSmall(BuildContext context) {
    return GoogleFonts.jetBrainsMono(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.5,
    );
  }

  static TextStyle extremeLight(BuildContext context, {double? fontSize}) {
    return GoogleFonts.tajawal(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w200,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  static TextStyle extremeBold(BuildContext context, {double? fontSize}) {
    return GoogleFonts.tajawal(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.25,
      height: 1.4,
    );
  }


  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      displayLarge: displayLarge(context),
      displayMedium: displayMedium(context),
      displaySmall: displaySmall(context),
      headlineLarge: headlineLarge(context),
      headlineMedium: headlineMedium(context),
      headlineSmall: headlineSmall(context),
      titleLarge: titleLarge(context),
      titleMedium: titleMedium(context),
      titleSmall: titleSmall(context),
      bodyLarge: bodyLarge(context),
      bodyMedium: bodyMedium(context),
      bodySmall: bodySmall(context),
      labelLarge: labelLarge(context),
      labelMedium: labelMedium(context),
      labelSmall: labelSmall(context),
    );
  }
}
