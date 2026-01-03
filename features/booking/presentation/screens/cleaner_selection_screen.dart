import 'dart:async';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class CleanerSelectionScreen extends StatefulWidget {
  const CleanerSelectionScreen({super.key});

  @override
  State<CleanerSelectionScreen> createState() => _CleanerSelectionScreenState();
}

class _CleanerSelectionScreenState extends State<CleanerSelectionScreen> {
  List<String> _selectedCleanerIds = [];
  StreamSubscription? _blocSubscription;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<BookingBloc>();
    final state = bloc.state;
    _selectedCleanerIds = List.from(state.selectedCleanerIds);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(const LoadAvailableCleaners());
    });
  }

  @override
  void dispose() {
    _blocSubscription?.cancel();
    super.dispose();
  }

  void _onCleanerSelected(String cleanerId) {
    final state = context.read<BookingBloc>().state;
    final cleanerCount = state.cleanerCount ?? 1;

    debugPrint(
      'Cleaner selected: $cleanerId, Current count: ${_selectedCleanerIds.length}, Allowed: $cleanerCount',
    );

    setState(() {
      if (_selectedCleanerIds.contains(cleanerId)) {
        // Deselect if already selected
        _selectedCleanerIds.remove(cleanerId);
        debugPrint(
          'Deselected cleaner: $cleanerId, Now selected: ${_selectedCleanerIds.length}',
        );
      } else {
        // Select if not at limit
        if (_selectedCleanerIds.length < cleanerCount) {
          _selectedCleanerIds.add(cleanerId);
          debugPrint(
            'Selected cleaner: $cleanerId, Now selected: ${_selectedCleanerIds.length}',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.canSelectWorkers(cleanerCount))),
          );
          debugPrint(
            'Cannot select more: Already have ${_selectedCleanerIds.length}, limit is $cleanerCount',
          );
          return;
        }
      }
    });

    context.read<BookingBloc>().add(
      SelectCleaners(List.from(_selectedCleanerIds)),
    );
  }

  void _onContinue() {
    final state = context.read<BookingBloc>().state;
    final cleanerCount = state.cleanerCount ?? 1;

    debugPrint(
      'Continue pressed: Selected ${_selectedCleanerIds.length}, Required: $cleanerCount',
    );

    if (_selectedCleanerIds.length == cleanerCount) {
      context.pushNamed(AppRouteNames.bookingLocationSelection);
    } else {
      context.showSnackBar(context.t.pleaseSelectCleaner);
    }
  }

  String _getSelectionText(int cleanerCount) {
    final selectedCount = _selectedCleanerIds.length;
    return context.t.selectedWorkers(selectedCount, cleanerCount);
  }

  String _getExperienceText(DateTime joinedDate) {
    final now = DateTime.now();
    final difference = now.difference(joinedDate);
    final months = (difference.inDays / 30).floor();
    return context.t.experienceMonths(months);
  }

  double _getCleanerPrice(Cleaner cleaner, double basePrice) {
    // Add rating and experience bonuses
    final ratingBonus = cleaner.rating * 5;
    final experienceMonths =
        (DateTime.now().difference(cleaner.joinedDate).inDays / 30).floor();
    final experienceBonus = experienceMonths * 2;
    return basePrice + ratingBonus + experienceBonus;
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) {
      return Colors.green;
    } else if (rating >= 3.0) {
      return Colors.yellow.shade700;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final cleaners = state.availableCleaners;
        final cleanerCount = state.cleanerCount ?? 1;

        debugPrint(
          'Building cleaner selection: Available cleaners: ${cleaners.length}, Required count: $cleanerCount, Currently selected: ${_selectedCleanerIds.length}',
        );

        return Directionality(
          textDirection: material.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBarWidget(title: context.t.step3),
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                // Yellow header

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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  context.t.selectCleaner,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.headlineSmall(context)
                                      .copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 24),
                                // Cleaner cards
                                if (state.status == BookingFlowStatus.error)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: AppColors.error,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            state.errorMessage ??
                                                context.t.errorLoadingData,
                                            textAlign: TextAlign.center,
                                            style: AppTypography.bodyMedium(
                                              context,
                                            ).copyWith(color: AppColors.error),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (cleaners.isEmpty)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else
                                  ...cleaners.map((cleaner) {
                                    final isSelected = _selectedCleanerIds
                                        .contains(cleaner.id);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _CleanerCard(
                                        cleaner: cleaner,
                                        isSelected: isSelected,
                                        price: _getCleanerPrice(
                                          cleaner,
                                          state.service?.price ?? 0.0,
                                        ),
                                        experienceText: _getExperienceText(
                                          cleaner.joinedDate,
                                        ),
                                        ratingColor: _getRatingColor(
                                          cleaner.rating,
                                        ),
                                        onTap: () =>
                                            _onCleanerSelected(cleaner.id),
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                        // Footer
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 50),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border(
                              top: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              if (_selectedCleanerIds.isNotEmpty)
                                Text(
                                  _getSelectionText(cleanerCount),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMedium(
                                    context,
                                  ).copyWith(color: AppColors.textSecondary),
                                )
                              else
                                Text(
                                  context.t.pleaseSelectCleaner,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMedium(
                                    context,
                                  ).copyWith(color: AppColors.textSecondary),
                                ),
                              const SizedBox(height: 16),
                              // Continue button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.info,
                                    foregroundColor: AppColors.textOnSecondary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _onContinue,
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
        );
      },
    );
  }
}

class _CleanerCard extends StatelessWidget {
  final Cleaner cleaner;
  final bool isSelected;
  final double price;
  final String experienceText;
  final Color ratingColor;
  final VoidCallback onTap;

  const _CleanerCard({
    required this.cleaner,
    required this.isSelected,
    required this.price,
    required this.experienceText,
    required this.ratingColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.border,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.info : AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.info : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textOnSecondary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Avatar image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: cleaner.avatarUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleaner.name,
                    style: AppTypography.titleLarge(context).copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experienceText,
                    style: AppTypography.bodySmall(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${price.toStringAsFixed(0)} د.ل',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ratingColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cleaner.rating.toStringAsFixed(1),
                          style: AppTypography.bodySmall(context).copyWith(
                            color: ratingColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
