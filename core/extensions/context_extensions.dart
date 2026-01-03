import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:buzzy_bee/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtensions on BuildContext {
  /// Get localization instance
  AppLocalizations get t => AppLocalizations.of(this);

  /// Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// MediaQuery
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  User get user => read<AppBloc>().state.user;


  /// Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;

  /// Show SnackBar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Show Error SnackBar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Dismiss keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
