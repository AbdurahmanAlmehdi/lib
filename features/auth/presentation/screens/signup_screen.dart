import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/utils/app_validator.dart';
import 'package:buzzy_bee/core/widgets/custom_elevated_button.dart';
import 'package:buzzy_bee/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:buzzy_bee/features/auth/presentation/bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _nameFieldKey = GlobalKey<FormFieldState<String>>();
  final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState<String>>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validateAndFocus() {
    final nameValid = _nameFieldKey.currentState?.validate() ?? false;
    if (!nameValid) {
      _nameFocusNode.requestFocus();
      return;
    }

    final phoneValid = _phoneFieldKey.currentState?.validate() ?? false;
    if (!phoneValid) {
      _phoneFocusNode.requestFocus();
      return;
    }

    final emailValid = _emailFieldKey.currentState?.validate() ?? false;
    if (!emailValid) {
      _emailFocusNode.requestFocus();
      return;
    }

    final passwordValid = _passwordFieldKey.currentState?.validate() ?? false;
    if (!passwordValid) {
      _passwordFocusNode.requestFocus();
      return;
    }

    final confirmPasswordValid =
        _confirmPasswordFieldKey.currentState?.validate() ?? false;
    if (!confirmPasswordValid) {
      _confirmPasswordFocusNode.requestFocus();
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<SignupCubit>().signup(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, AuthState>(
      listener: (context, state) {
        if (state.status == SubmissionStatus.registered) {
          context.showSnackBar(context.t.registrationSuccessful);
          context.goNamed(AppRouteNames.login);
        } else if (state.status == SubmissionStatus.error) {
          context.showErrorSnackBar(state.error);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.t.signUp,
                            style: AppTypography.headlineLarge(context)
                                .copyWith(
                                  color: AppColors.textOnSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.t.signUpAndLetUsHandleTheMess,
                            style: AppTypography.bodyLarge(context).copyWith(
                              color: AppColors.textOnSecondary.withValues(
                                alpha: 0.9,
                              ),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),
                              TextFormField(
                                key: _nameFieldKey,
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  _phoneFocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: context.t.name,
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                ),
                                validator: (value) =>
                                    AppValidator.name(value, context.t),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                key: _phoneFieldKey,
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  _emailFocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: context.t.phone,
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                ),
                                validator: (value) =>
                                    AppValidator.phone(value, context.t),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                key: _emailFieldKey,
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  _passwordFocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: context.t.email,
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                ),
                                validator: (value) => AppValidator.email(
                                  value,
                                  context.t,
                                  isRequired: true,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                key: _passwordFieldKey,
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  _confirmPasswordFocusNode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: context.t.password,
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                ),
                                validator: (value) =>
                                    AppValidator.password(value, context.t),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                key: _confirmPasswordFieldKey,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  _validateAndFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: context.t.confirmPassword,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceVariant,
                                ),
                                validator: (value) =>
                                    AppValidator.confirmPassword(
                                      value,
                                      _passwordController.text,
                                      context.t,
                                    ),
                              ),
                              const SizedBox(height: 38),
                              BlocBuilder<SignupCubit, AuthState>(
                                builder: (context, state) {
                                  return CustomElevatedButton(
                                    onPressed: _validateAndFocus,
                                    buttonText: context.t.signUp,
                                    isLoading:
                                        state.status ==
                                        SubmissionStatus.loading,
                                    hideGradient: true,
                                    buttonColor: AppColors.secondary,
                                    foregroundColor: AppColors.textOnSecondary,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.t.alreadyHaveAnAccount,
                                    style: AppTypography.bodyMedium(context),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.goNamed(AppRouteNames.login);
                                    },
                                    child: Text(context.t.login),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.goNamed(AppRouteNames.welcome),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textOnSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
