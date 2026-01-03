import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _phoneHasFocus = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {
        _phoneHasFocus = _phoneFocusNode.hasFocus;
      });
    });
  }

  String? _getPhonePlaceholder() {
    final user = context.user;
    // Get the phone number that the user registered with
    String phone = user.phone;

    // Remove +218 prefix if exists
    if (phone.startsWith('+218')) {
      phone = phone.substring(4); // Remove '+218'
    } else if (phone.startsWith('218')) {
      phone = phone.substring(3); // Remove '218'
    } else {
      phone = phone;
    }

    // Remove any remaining + sign from anywhere in the string
    phone = phone.replaceAll('+', '');

    // Return the phone number without + or prefix as placeholder
    return phone.isNotEmpty && phone != User.anonymous.phone ? phone : null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = '+218${_phoneController.text}';
      final user = context.user;

      context.read<AccountBloc>().add(
        AccountUpdateRequested(
          name: user.name,
          email: user.email,
          gender: user.gender,
          phone: phoneNumber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تغيير رقم الهاتف بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == AccountStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'حدث خطأ أثناء تحديث رقم الهاتف',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Directionality(
        textDirection: material.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBarWidget(title: 'تغيير رقم الهاتف'),
          backgroundColor: AppColors.primary, // Yellow-orange background
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              final isLoading = state.status == AccountStatus.loading;

              return Column(
                children: [
                  SizedBox(height: context.screenHeight * 0.4),
                  Expanded(
                    child: ClipPath(
                      clipper: _CurvedClipper(),
                      child: Container(
                        color: AppColors.surface,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 32,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Title
                                Center(
                                  child: Text(
                                    'تغيير رقم الهاتف',
                                    style: AppTypography.headlineMedium(context)
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Phone number label
                                Visibility(
                                  visible: !_phoneHasFocus,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'رقم الهاتف',
                                      style: AppTypography.bodyMedium(context)
                                          .copyWith(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                // Phone input field
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Directionality(
                                    textDirection: material.TextDirection.ltr,
                                    child: TextFormField(
                                      controller: _phoneController,
                                      focusNode: _phoneFocusNode,
                                      keyboardType: TextInputType.phone,
                                      textDirection: material.TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: AppTypography.bodyLarge(
                                        context,
                                      ).copyWith(color: AppColors.textPrimary),
                                      decoration: InputDecoration(
                                        hintText: _getPhonePlaceholder(),
                                        hintStyle:
                                            AppTypography.bodyLarge(
                                              context,
                                            ).copyWith(
                                              color: AppColors.textDisabled,
                                            ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                        prefix: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Directionality(
                                            textDirection:
                                                material.TextDirection.ltr,
                                            child: Text(
                                              '+218',
                                              style:
                                                  AppTypography.bodyLarge(
                                                    context,
                                                  ).copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى إدخال رقم الهاتف';
                                        }
                                        if (value.length < 9) {
                                          return 'رقم الهاتف غير صحيح';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Submit button
                                ElevatedButton(
                                  onPressed: isLoading ? null : _onSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF2196F3,
                                    ), // Blue
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    disabledBackgroundColor:
                                        AppColors.textDisabled,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'تعديل',
                                          style:
                                              AppTypography.bodyLarge(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
