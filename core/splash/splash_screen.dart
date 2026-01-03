import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!kIsWeb)
            Hero(
              tag: 'appLogo',
              child: Image.asset('assets/images/appLogo.png'),
            ),
          const SizedBox(height: 32),
          SpinKitFadingCube(color: AppColors.secondary, size: 50),
        ],
      ),
    );
  }
}
