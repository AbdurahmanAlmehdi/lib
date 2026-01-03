import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/utils/app_validator.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _currentPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _firstErrorField;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تغيير كلمة المرور بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == AccountStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'فشل تغيير كلمة المرور'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ClipPath(
                clipper: _CurvedClipper(),
                child: Container(
                  color: AppColors.surface,
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 32,
                        bottom: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title in white section - centered
                            Center(
                              child: Text(
                                'اعادة تعيين كلمة المرور',
                                style: AppTypography.headlineMedium(context)
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildPasswordFieldWithLabel(
                              controller: _currentPasswordController,
                              focusNode: _currentPasswordFocusNode,
                              label: 'كلمة السر الحالية',
                              obscureText: _obscureCurrentPassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscureCurrentPassword =
                                      !_obscureCurrentPassword;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildPasswordFieldWithLabel(
                              controller: _newPasswordController,
                              focusNode: _newPasswordFocusNode,
                              label: 'كلمة المرور الجديدة',
                              obscureText: _obscureNewPassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildPasswordFieldWithLabel(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              label: 'تأكيد كلمة المرور',
                              obscureText: _obscureConfirmPassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            const SizedBox(height: 40),
                            _buildSubmitButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFieldWithLabel({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            label,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary, // Same color as personal account
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (_firstErrorField == null) return null;
            if (controller == _currentPasswordController &&
                _firstErrorField == 'current') {
              return AppValidator.password(value, context.t);
            }
            if (controller == _newPasswordController &&
                _firstErrorField == 'new') {
              return AppValidator.password(value, context.t);
            }
            if (controller == _confirmPasswordController &&
                _firstErrorField == 'confirm') {
              return AppValidator.confirmPassword(
                value,
                _newPasswordController.text,
                context.t,
              );
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final isLoading = state.status == AccountStatus.loading;
        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  _validateAndFocusFirstError();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D85FD),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'تعديل',
                  style: AppTypography.bodyLarge(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
        );
      },
    );
  }

  void _validateAndFocusFirstError() {
    setState(() {
      _firstErrorField = null;
    });

    // Validate current password first
    final currentPasswordError = AppValidator.password(
      _currentPasswordController.text,
      context.t,
    );
    if (currentPasswordError != null) {
      setState(() {
        _firstErrorField = 'current';
      });
      _currentPasswordFocusNode.requestFocus();
      _formKey.currentState?.validate();
      return;
    }

    // Validate new password
    final newPasswordError = AppValidator.password(
      _newPasswordController.text,
      context.t,
    );
    if (newPasswordError != null) {
      setState(() {
        _firstErrorField = 'new';
      });
      _newPasswordFocusNode.requestFocus();
      _formKey.currentState?.validate();
      return;
    }

    // Validate confirm password
    final confirmPasswordError = AppValidator.confirmPassword(
      _confirmPasswordController.text,
      _newPasswordController.text,
      context.t,
    );
    if (confirmPasswordError != null) {
      setState(() {
        _firstErrorField = 'confirm';
      });
      _confirmPasswordFocusNode.requestFocus();
      _formKey.currentState?.validate();
      return;
    }

    // Check if passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _firstErrorField = 'confirm';
      });
      _confirmPasswordFocusNode.requestFocus();
      _formKey.currentState?.validate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t.passwordsDoNotMatch),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // All validations passed - call the bloc to change password
    context.read<AccountBloc>().add(
      ChangePasswordRequested(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 30;

    final path = Path();

    // start from top-left after radius
    path.moveTo(0, radius);

    // top-left rounded corner
    path.quadraticBezierTo(0, 0, radius, 0);

    // top edge
    path.lineTo(size.width - radius, 0);

    // top-right rounded corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // right edge
    path.lineTo(size.width, size.height);

    // bottom edge
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
