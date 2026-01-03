import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/utils/app_validator.dart';
import 'package:buzzy_bee/core/widgets/custom_elevated_button.dart';
import 'package:buzzy_bee/features/auth/presentation/cubit/login_cubit.dart';
import 'package:buzzy_bee/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: Scaffold(
        body: BlocListener<LoginCubit, AuthState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.error) {
              context.showErrorSnackBar(state.error);
            }
          },
          child: Container(
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
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.t.login,
                                style: AppTypography.headlineLarge(context)
                                    .copyWith(
                                      color: AppColors.textOnSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.t.signInToContinue,
                                style: AppTypography.bodyLarge(context)
                                    .copyWith(
                                      color: AppColors.textOnSecondary
                                          .withValues(alpha: 0.9),
                                      fontSize: 18,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
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
                                  const SizedBox(height: 32),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
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
                                            _obscurePassword =
                                                !_obscurePassword;
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
                                  const SizedBox(height: 32),
                                  BlocBuilder<LoginCubit, AuthState>(
                                    builder: (context, state) {
                                      return CustomElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<LoginCubit>().login(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                          }
                                        },
                                        buttonText: context.t.login,
                                        isLoading:
                                            state.status ==
                                            SubmissionStatus.loading,
                                        hideGradient: true,
                                        buttonColor: AppColors.secondary,
                                        foregroundColor:
                                            AppColors.textOnSecondary,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        context.t.dontHaveAnAccount,
                                        style: AppTypography.bodyMedium(
                                          context,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.goNamed(
                                            AppRouteNames.register,
                                          );
                                        },
                                        child: Text(context.t.signUp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
