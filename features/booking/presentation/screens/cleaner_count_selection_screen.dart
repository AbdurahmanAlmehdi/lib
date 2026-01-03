import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';

class CleanerCountSelectionScreen extends StatefulWidget {
  const CleanerCountSelectionScreen({super.key});

  @override
  State<CleanerCountSelectionScreen> createState() =>
      _CleanerCountSelectionScreenState();
}

class _CleanerCountSelectionScreenState
    extends State<CleanerCountSelectionScreen> {
  int? _selectedCount;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<BookingBloc>();
    _selectedCount = bloc.state.cleanerCount;
    bloc.add(const LoadAvailableCleanersCount());
  }

  void _onCountSelected(int count) {
    setState(() {
      _selectedCount = count;
    });
    context.read<BookingBloc>().add(SelectCleanerCount(count));
  }

  void _onContinue() {
    if (_selectedCount != null) {
      context.pushNamed(AppRouteNames.cleanerSelection);
    } else {
      context.showSnackBar(context.t.pleaseSelectCleanerCount);
    }
  }

  String _getCountText(int count) {
    return context.t.needWorkers(count);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(title: context.t.step2),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      // Title
                      Text(
                        context.t.selectCleanerCount,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Count buttons
                      BlocBuilder<BookingBloc, BookingState>(
                        buildWhen: (previous, current) =>
                            previous.maxAvailableCleaners !=
                                current.maxAvailableCleaners ||
                            previous.isLoadingCleanerCount !=
                                current.isLoadingCleanerCount,
                        builder: (context, state) {
                          if (state.isLoadingCleanerCount) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 64),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final maxCount = state.maxAvailableCleaners ?? 0;

                          if (maxCount == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.t.noCleanersAvailableForDate,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyLarge(
                                      context,
                                    ).copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            );
                          }

                          final displayCount = maxCount.clamp(1, 6);
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: List.generate(displayCount, (index) {
                              final count = index + 1;
                              final isSelected = _selectedCount == count;
                              return _CountButton(
                                count: count,
                                isSelected: isSelected,
                                onTap: () => _onCountSelected(count),
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Summary
                      BlocBuilder<BookingBloc, BookingState>(
                        buildWhen: (previous, current) =>
                            previous.maxAvailableCleaners !=
                            current.maxAvailableCleaners,
                        builder: (context, state) {
                          final maxCount = state.maxAvailableCleaners ?? 0;

                          if (maxCount == 0) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              const Divider(color: AppColors.border),
                              const SizedBox(height: 16),
                              Text(
                                _selectedCount != null
                                    ? _getCountText(_selectedCount!)
                                    : context.t.pleaseSelectCleanerCount,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium(
                                  context,
                                ).copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      // Continue button
                      BlocBuilder<BookingBloc, BookingState>(
                        buildWhen: (previous, current) =>
                            previous.maxAvailableCleaners !=
                            current.maxAvailableCleaners,
                        builder: (context, state) {
                          final maxCount = state.maxAvailableCleaners ?? 0;
                          final canContinue =
                              maxCount > 0 && _selectedCount != null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canContinue
                                      ? AppColors.info
                                      : AppColors.textDisabled,
                                  foregroundColor: AppColors.textOnSecondary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: canContinue ? _onContinue : null,
                                child: Text(
                                  context.t.continueText,
                                  style: AppTypography.titleLarge(context)
                                      .copyWith(
                                        color: AppColors.textOnSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountButton({
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.info : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: AppTypography.headlineMedium(context).copyWith(
              color: isSelected
                  ? AppColors.textOnSecondary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
