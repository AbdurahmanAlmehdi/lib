import 'package:buzzy_bee/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenHeight * 0.35; // 35% of screen height

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!kIsWeb)
                    Hero(
                      tag: 'appLogo',
                      child: Image.asset(
                        'assets/images/appLogo.png',
                        width: logoSize.clamp(200.0, 400.0),
                        height: logoSize.clamp(200.0, 400.0),
                        fit: BoxFit.contain,
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    context.t.welcomeToBuzzyBee,
                    style: AppTypography.headlineLarge(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.t.yourTrustedCleaningServicePartner,
                    style: AppTypography.bodyLarge(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  CustomElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppRouteNames.login);
                    },
                    buttonText: context.t.login,
                    isLoading: false,
                    isOutlined: false,
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppRouteNames.register);
                    },
                    buttonText: context.t.signUp,
                    isLoading: false,
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
