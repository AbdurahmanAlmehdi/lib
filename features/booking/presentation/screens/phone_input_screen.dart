import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/utils/app_validator.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  late TextEditingController _phoneController;
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize phone from state or user
    if (!_isInitialized) {
      final state = context.read<BookingBloc>().state;
      // First, try to get from state
      if (state.phoneNumber == null || state.phoneNumber!.isEmpty) {
        // Fallback to user phone from context
        final user = context.user;
        if (user.phone.isNotEmpty && user.phone != User.anonymous.phone) {
          // Save phone number to bloc state
          context.read<BookingBloc>().add(SelectPhoneNumber(user.phone));
          debugPrint('Saved phone from user to state: ${user.phone}');
        }
      } else {
        debugPrint('Using phone from state: ${state.phoneNumber}');
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onBook() {
    final phoneNumber = _phoneController.text.trim();
    final validationError = AppValidator.phone(phoneNumber, context.t);

    if (validationError != null) {
      context.showSnackBar(validationError);
      return;
    }

    final fullPhoneNumber = '+218$phoneNumber';

    final bloc = context.read<BookingBloc>();
    bloc.add(SelectPhoneNumber(fullPhoneNumber));
    bloc.add(const ConfirmBooking());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == BookingFlowStatus.success ||
              current.status == BookingFlowStatus.error),
      listener: (context, state) {
        if (state.status == BookingFlowStatus.success) {
          context.pushNamed(AppRouteNames.bookingConfirmation);
        } else if (state.status == BookingFlowStatus.error) {
          context.showErrorSnackBar(state.errorMessage ?? context.t.error);
        }
      },
      child: Directionality(
        textDirection: material.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBarWidget(title: context.t.step5),
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // White content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              // Title
                              Text(
                                context.t.whatIsYourPhoneNumber,
                                textAlign: TextAlign.center,
                                style: AppTypography.headlineSmall(context)
                                    .copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              // Description
                              Text(
                                context.t.phoneNumberDescription,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium(
                                  context,
                                ).copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 32),
                              // Phone input field
                              BlocBuilder<BookingBloc, BookingState>(
                                builder: (context, state) {
                                  // Get placeholder from state
                                  String hintText = '912345678';
                                  if (state.phoneNumber != null &&
                                      state.phoneNumber!.isNotEmpty) {
                                    String phone = state.phoneNumber!;

                                    // Remove +218 prefix for display
                                    if (phone.startsWith('+218')) {
                                      hintText = phone.substring(
                                        4,
                                      ); // Remove '+218'
                                    } else if (phone.startsWith('218')) {
                                      hintText = phone.substring(
                                        3,
                                      ); // Remove '218'
                                    } else {
                                      hintText = phone;
                                    }

                                    // Remove any remaining + sign from anywhere in the string
                                    hintText = hintText.replaceAll('+', '');
                                  }
                                  return _PhoneInputField(
                                    controller: _phoneController,
                                    focusNode: _phoneFocusNode,
                                    hintText: hintText,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Footer with booking button
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 50),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border(
                            top: BorderSide(color: AppColors.border, width: 1),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Order price
                            const _OrderPriceDisplay(),
                            const SizedBox(height: 16),
                            // Wallet payment option
                            const _WalletPaymentOption(),
                            const SizedBox(height: 16),
                            BlocBuilder<BookingBloc, BookingState>(
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                final isLoading =
                                    state.status ==
                                    BookingFlowStatus.confirming;
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.info,
                                      foregroundColor:
                                          AppColors.textOnSecondary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: isLoading ? null : _onBook,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            context.t.book,
                                            style:
                                                AppTypography.titleLarge(
                                                  context,
                                                ).copyWith(
                                                  color:
                                                      AppColors.textOnSecondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  const _PhoneInputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Directionality(
        textDirection: material.TextDirection.ltr,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          textDirection: material.TextDirection.ltr,
          textAlign: TextAlign.left,
          style: AppTypography.bodyLarge(
            context,
          ).copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyLarge(
              context,
            ).copyWith(color: AppColors.textDisabled),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            prefix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Directionality(
                textDirection: material.TextDirection.ltr,
                child: Text(
                  '+218',
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderPriceDisplay extends StatelessWidget {
  const _OrderPriceDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final servicePrice = state.service?.price ?? 0.0;

        // Get cleaner count
        final cleanerCount = state.cleanerCount ?? 1;

        // Calculate total price: service price * cleaner count
        final totalPrice = servicePrice * cleanerCount;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${context.t.orderPrice} : ',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall(context).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${totalPrice.toStringAsFixed(0)} ${context.t.currency}',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class _WalletPaymentOption extends StatelessWidget {
  const _WalletPaymentOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            final servicePrice = bookingState.service?.price ?? 0.0;
            final cleanerCount = bookingState.cleanerCount ?? 1;
            final totalPrice = servicePrice * cleanerCount;
            final walletBalance = walletState.wallet?.balance ?? 0.0;
            final walletEnough = walletBalance >= totalPrice;
            final useWallet = bookingState.useWallet;

            return Column(
              children: [
                GestureDetector(
                  onTap: walletEnough
                      ? () => context.read<BookingBloc>().add(
                          SetUseWallet(!useWallet),
                        )
                      : () {
                          context.pushNamed(AppRouteNames.wallet);
                        },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: useWallet
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: useWallet ? AppColors.primary : AppColors.border,
                        width: useWallet ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          useWallet
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: useWallet
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'استخدام المحفظة',
                                style: AppTypography.bodyLarge(context)
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الرصيد المتاح: ${walletBalance.toStringAsFixed(2)} ${context.t.currency}',
                                style: AppTypography.bodySmall(
                                  context,
                                ).copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.read<BookingBloc>().add(SetUseWallet(false));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !useWallet
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !useWallet
                            ? AppColors.primary
                            : AppColors.border,
                        width: !useWallet ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          !useWallet
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: !useWallet
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'الدفع نقداً',
                          style: AppTypography.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
