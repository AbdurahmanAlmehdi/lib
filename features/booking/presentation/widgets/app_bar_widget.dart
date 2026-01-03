import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.headlineSmall(context).copyWith(
          color: AppColors.textOnSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(AppRouteNames.home),
          icon: const Icon(Icons.home),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
