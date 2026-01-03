import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/utils/app_validator.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';
import 'package:go_router/go_router.dart';

class PersonalAccountScreen extends StatefulWidget {
  const PersonalAccountScreen({super.key});

  @override
  State<PersonalAccountScreen> createState() => _PersonalAccountScreenState();
}

class _PersonalAccountScreenState extends State<PersonalAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedGender;

  final List<String> _genders = ['ذكر', 'أنثى'];

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _nameHasFocus = false;
  bool _emailHasFocus = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      setState(() {
        _nameHasFocus = _nameFocusNode.hasFocus;
      });
    });
    _emailFocusNode.addListener(() {
      setState(() {
        _emailHasFocus = _emailFocusNode.hasFocus;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nameController.text.isEmpty && _emailController.text.isEmpty) {
      final user = context.user;
      _nameController.text = user.name;
      _emailController.text = user.email ?? '';

      if (user.gender != null) {
        if (user.gender == 'male') {
          _selectedGender = 'ذكر';
        } else if (user.gender == 'female') {
          _selectedGender = 'أنثى';
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  String? _getGenderValue() {
    if (_selectedGender == 'ذكر') return 'male';
    if (_selectedGender == 'أنثى') return 'female';
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AccountBloc>().add(
        AccountUpdateRequested(
          name: _nameController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          gender: _getGenderValue(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success) {
          // context.pop();
          context.showSnackBar(context.t.success);
        } else if (state.status == AccountStatus.error) {
          context.showErrorSnackBar(state.errorMessage ?? context.t.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ClipPath(
                clipper: _CurvedClipper(),
                child: Container(
                  color: AppColors.surface,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              context.t.personalAccount,
                              style: AppTypography.headlineMedium(context)
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildTextFieldWithLabel(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            label: context.t.name,
                            icon: Icons.person,
                            hasFocus: _nameHasFocus,
                            validator: (value) =>
                                AppValidator.name(value, context.t),
                          ),
                          const SizedBox(height: 24),
                          _buildGenderDropdown(),
                          const SizedBox(height: 24),
                          _buildTextFieldWithLabel(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            label: context.t.email,
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            hasFocus: _emailHasFocus,
                            validator: (value) =>
                                AppValidator.email(value, context.t),
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 300,
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

  Widget _buildTextFieldWithLabel({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required bool hasFocus,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: !hasFocus,
          child: Padding(
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
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
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
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'الجنس',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedGender,
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
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            prefixIcon: Icon(
              Icons.wc,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: _genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                textDirection: TextDirection.rtl,
                style: AppTypography.bodyMedium(context),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          hint: Text(
            'اختر الجنس',
            textDirection: TextDirection.rtl,
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final isLoading = state.status == AccountStatus.loading;
        return ElevatedButton(
          onPressed: isLoading ? null : _onSubmit,
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
                  context.t.confirm,
                  style: AppTypography.bodyLarge(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
        );
      },
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
