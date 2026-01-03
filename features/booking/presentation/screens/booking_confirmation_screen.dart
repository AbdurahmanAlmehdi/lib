import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  String _formatArabicDate(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} , ${date.year}';
  }

  String _formatTime(String time) {
    try {
      // Time format: "11:00 AM" or "11:00 صباحاً" or "11:00"
      if (time.contains('AM') ||
          time.contains('PM') ||
          time.contains('صباحاً') ||
          time.contains('مساءً')) {
        return time;
      }
      // If it's in 24-hour format, convert to 12-hour with Arabic
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1].split(' ').first; // Remove any extra text
        if (hour < 12) {
          return '$hour:$minute صباحاً';
        } else {
          final hour12 = hour == 12 ? 12 : hour - 12;
          return '$hour12:$minute مساءً';
        }
      }
      return time;
    } catch (_) {
      return time;
    }
  }

  String _getCleanerNames(BookingState state) {
    if (state.selectedCleanerIds.isEmpty || state.availableCleaners.isEmpty) {
      return '-';
    }
    final cleanerNames = <String>[];
    for (final id in state.selectedCleanerIds) {
      try {
        final cleaner = state.availableCleaners.firstWhere((c) => c.id == id);
        cleanerNames.add(cleaner.name);
      } catch (_) {
        // If cleaner not found, skip it
        continue;
      }
    }
    return cleanerNames.isEmpty ? '-' : cleanerNames.join('، ');
  }

  String _generateTransactionNumber() {
    // Generate a random transaction number
    final random = DateTime.now().millisecondsSinceEpoch;
    return random.toString().substring(0, 9);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.user;
    final transactionNumber = _generateTransactionNumber();

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Directionality(
          textDirection: material.TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          // Success Icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.textOnPrimary,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Success Title
                          Text(
                            context.t.bookingSuccessful,
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineLarge(context)
                                .copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          // Transaction Number
                          Text(
                            '${context.t.transactionNumber} : $transactionNumber',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium(
                              context,
                            ).copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 40),
                          // Booking Details
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _DetailRow(
                                  label: context.t.name,
                                  value: user.name,
                                ),
                                const SizedBox(height: 16),
                                _PhoneNumberRow(
                                  label: context.t.phone,
                                  phoneNumber:
                                      (state.phoneNumber != null &&
                                          state.phoneNumber!.isNotEmpty)
                                      ? state.phoneNumber!
                                      : user.phone,
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.cleanerCount,
                                  value: state.cleanerCount?.toString() ?? '-',
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.cleaners,
                                  value: _getCleanerNames(state),
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.date,
                                  value: state.selectedDate != null
                                      ? _formatArabicDate(state.selectedDate!)
                                      : '-',
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.service,
                                  value: state.serviceTitle ?? '-',
                                ),
                                const SizedBox(height: 16),
                                _PriceRow(state: state),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.time,
                                  value: state.selectedTime != null
                                      ? _formatTime(state.selectedTime!)
                                      : '-',
                                ),
                                const SizedBox(height: 16),
                                _DetailRow(
                                  label: context.t.location,
                                  value: state.selectedLocation?.address ?? '-',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Done Button
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          foregroundColor: AppColors.textOnSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Navigate to home and reset booking
                          context.read<BookingBloc>().add(const ResetBooking());
                          context.go(AppRoutes.home);
                        },
                        child: Text(
                          context.t.done,
                          style: AppTypography.titleLarge(context).copyWith(
                            color: AppColors.textOnSecondary,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: material.TextDirection.rtl,
      children: [
        // Label (right side in RTL - comes first)
        Text(
          label,
          textAlign: TextAlign.right,
          style: AppTypography.bodyMedium(
            context,
          ).copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        // Value (left side in RTL - comes second)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final BookingState state;

  const _PriceRow({required this.state});

  double _calculateOrderPrice() {
    // Get service price from service
    final servicePrice = state.service?.price ?? 0.0;

    // Get cleaner count
    final cleanerCount = state.cleanerCount ?? 1;

    // Calculate total price: service price * cleaner count
    return servicePrice * cleanerCount;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateOrderPrice();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: material.TextDirection.rtl,
      children: [
        // Label (right side in RTL - comes first)
        Text(
          context.t.price,
          textAlign: TextAlign.right,
          style: AppTypography.bodyMedium(
            context,
          ).copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        // Value (left side in RTL - comes second)
        Expanded(
          child: Directionality(
            textDirection: material.TextDirection.ltr,
            child: Text(
              '${totalPrice.toStringAsFixed(0)} د.ل',
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium(
                context,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneNumberRow extends StatelessWidget {
  final String label;
  final String phoneNumber;

  const _PhoneNumberRow({required this.label, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // Ensure phone number starts with +
    String displayPhone = phoneNumber;
    if (!displayPhone.startsWith('+')) {
      if (displayPhone.startsWith('218')) {
        displayPhone = '+$displayPhone';
      } else {
        displayPhone = '+218$displayPhone';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: material.TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (right side in RTL - comes first)
        Text(
          label,
          textAlign: TextAlign.right,
          style: AppTypography.bodyMedium(
            context,
          ).copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        // Phone number with LTR direction (left side in RTL - comes second)
        Directionality(
          textDirection: material.TextDirection.ltr,
          child: Text(
            displayPhone,
            textAlign: TextAlign.left,
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
