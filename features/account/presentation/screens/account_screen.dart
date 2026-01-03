import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.user;

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            _ProfileCard(user: user),
            const SizedBox(height: 16),
            _GeneralCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  final User user;

  const _ProfileCard({required this.user});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final imageFile = File(image.path);
        setState(() {
          _selectedImage = imageFile;
        });

        // Convert image to base64
        try {
          final bytes = await imageFile.readAsBytes();
          final base64String = base64Encode(bytes);

          // Update user avatar in database
          if (context.mounted) {
            context.read<AccountBloc>().add(
              UpdateAvatarRequested(avatarBase64: base64String),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ أثناء تحويل الصورة'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء اختيار الصورة'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success && _selectedImage != null) {
          // Image saved successfully, clear local state
          setState(() {
            _selectedImage = null;
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم حفظ الصورة بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        } else if (state.status == AccountStatus.error &&
            _selectedImage != null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ أثناء حفظ الصورة'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          // Get updated user from state if available, otherwise use widget.user
          final currentUser = state.user ?? widget.user;
          final isLoading =
              state.status == AccountStatus.loading && _selectedImage != null;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.surfaceVariant,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : currentUser.avatarUrl != null
                            ? _getImageProvider(currentUser.avatarUrl!)
                            : null,
                        child:
                            _selectedImage == null &&
                                currentUser.avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.textSecondary,
                              )
                            : null,
                      ),
                      if (isLoading)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser.name,
                    style: AppTypography.headlineMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentUser.phone,
                    style: AppTypography.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  if (currentUser.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      currentUser.email!,
                      style: AppTypography.bodyMedium(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  _AccountMenuItem(
                    icon: Icons.person_outline,
                    title: context.t.personalAccount,
                    onTap: () {
                      context.push(AppRoutes.personalAccount);
                    },
                  ),
                  _AccountMenuItem(
                    icon: Icons.phone_outlined,
                    title: context.t.phone,
                    onTap: () {
                      context.push(AppRoutes.changePhone);
                    },
                  ),
                  _AccountMenuItem(
                    icon: Icons.lock_outline,
                    title: context.t.changePassword,
                    onTap: () {
                      context.push(AppRoutes.changePassword);
                    },
                  ),
                  _AccountMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'المحفظة',
                    onTap: () {
                      context.push(AppRoutes.wallet);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ImageProvider? _getImageProvider(String avatarUrl) {
    if (avatarUrl.startsWith('data:image')) {
      // Base64 image
      final base64String = avatarUrl.split(',')[1];
      final bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    } else {
      // Network image
      return CachedNetworkImageProvider(avatarUrl);
    }
  }
}

class _AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccountMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).toString().contains('ar');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTypography.bodyMedium(
                context,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GeneralMenuItem(
              icon: Icons.question_answer_outlined,
              title: context.t.frequentlyAskedQuestions,
              onTap: () {
                context.push(AppRoutes.faq);
              },
            ),
            const Divider(color: AppColors.border, height: 1),
            _GeneralMenuItem(
              icon: Icons.contact_page_outlined,
              title: context.t.contactUs,
              onTap: () {
                context.push(AppRoutes.contactUs);
              },
            ),
            const Divider(color: AppColors.border, height: 1),
            _GeneralMenuItem(
              icon: Icons.contact_support_outlined,
              title: context.t.aboutTheApp,
              onTap: () {
                context.push(AppRoutes.about);
              },
            ),
            const Divider(color: AppColors.border, height: 1),
            _LogoutMenuItem(),
          ],
        ),
      ),
    );
  }
}

class _GeneralMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _GeneralMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).toString().contains('ar');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTypography.bodyMedium(
                context,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(context.t.logout),
            content: Text(context.t.logoutConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.t.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<AppBloc>().add(const AppLoggedOut());
                },
                child: Text(context.t.logout),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 16),
        child: Text(
          context.t.logout,
          style: AppTypography.bodyMedium(
            context,
          ).copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
