import 'package:buzzy_bee/l10n/app_localizations.dart';

class AppValidator {
  AppValidator._();

  static String? required(
    String? value,
    AppLocalizations localizations, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return fieldName ?? localizations.pleaseEnterYourPhoneNumber;
    }
    return null;
  }

  static String? phone(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterYourPhoneNumber;
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return localizations.pleaseEnterAValidPhoneNumber;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterYourPassword;
    }
    if (value.length < 8) {
      return localizations.passwordMustBeAtLeast8Characters;
    }
    return null;
  }

  static String? email(
    String? value,
    AppLocalizations localizations, {
    bool isRequired = false,
  }) {
    if (value == null || value.isEmpty) {
      if (isRequired) {
        return localizations.pleaseEnterYourEmail;
      }
      return null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return localizations.pleaseEnterAValidEmail;
    }
    return null;
  }

  static String? name(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterYourName;
    }
    if (value.trim().length < 2) {
      return localizations.nameMustBeAtLeast2Characters;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String? password,
    AppLocalizations localizations,
  ) {
    if (value == null || value.isEmpty) {
      return localizations.pleaseConfirmYourPassword;
    }
    if (value != password) {
      return localizations.passwordsDoNotMatch;
    }
    return null;
  }
}
