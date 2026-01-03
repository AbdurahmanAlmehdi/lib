import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/search/presentation/bloc/search_bloc.dart';
import 'package:buzzy_bee/features/search/domain/entities/search_result.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['خدمات تنظيف', 'تنظيف منزلي'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeSearchItem(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const SearchCleared());
  }

  void _onServiceTap(Service service) {
    context.push(AppRoutes.booking, extra: service);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final isArabic = locale.contains('ar');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildSearchInput(context),
              const SizedBox(height: 32),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state.query.isEmpty) {
                    return _buildRecentSearchesSection();
                  }

                  if (state.status == SearchStatus.loading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.status == SearchStatus.error) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.errorMessage ??
                              context.t.errorOccurredWhileSearching,
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.error),
                        ),
                      ),
                    );
                  }

                  if (state.results.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          context.t.noResultsFound,
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return _buildSearchResults(state.results, isArabic);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location indicator (left side in RTL)
          Row(
            children: [
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.home);
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.locationPicker);
                },
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      context.t.currentLocation,
                      style: AppTypography.bodyMedium(
                        context,
                      ).copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Notification icon (right side in RTL)
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.notifications);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium(context),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: context.t.search,
                hintStyle: AppTypography.bodyMedium(
                  context,
                ).copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF90CAF9), // Light blue
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF90CAF9),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF90CAF9), // Light blue
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Cancel button (left side in RTL)
          GestureDetector(
            onTap: _onClearSearch,
            child: Text(
              context.t.cancel,
              style: AppTypography.bodyMedium(context).copyWith(
                color: const Color(0xFF2196F3), // Medium blue
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesSection() {
    if (_recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.t.searchRecommendations,
              style: AppTypography.headlineSmall(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _recentSearches.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                return _RecentSearchItem(
                  searchTerm: _recentSearches[index],
                  onDelete: () => _removeSearchItem(index),
                  onTap: () {
                    _searchController.text = _recentSearches[index];
                    _onSearchChanged(_recentSearches[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<SearchResult> results, bool isArabic) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: results.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final result = results[index];
          return _SearchResultItem(
            result: result,
            locale: isArabic ? 'ar' : 'en',
            onServiceTap: result.type == SearchResultType.service
                ? () => _onServiceTap(result.service!)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home icon (active - rightmost in RTL)
              _buildNavIcon(
                icon: Icons.home_outlined,
                isActive: true,
                onTap: () {
                  context.go(AppRoutes.home);
                },
              ),
              // Calendar icon
              _buildNavIcon(
                icon: Icons.calendar_today_outlined,
                isActive: false,
                onTap: () {
                  context.go(AppRoutes.orders);
                },
              ),
              // Star icon (Favorites)
              _buildNavIcon(
                icon: Icons.star_outline,
                isActive: false,
                onTap: () {
                  context.go(AppRoutes.favorites);
                },
              ),
              // Profile icon (leftmost in RTL)
              _buildNavIcon(
                icon: Icons.person_outline,
                isActive: false,
                onTap: () {
                  context.go(AppRoutes.account);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.primary : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  final String searchTerm;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _RecentSearchItem({
    required this.searchTerm,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                searchTerm,
                style: AppTypography.bodyMedium(
                  context,
                ).copyWith(color: AppColors.textPrimary),
              ),
            ),

            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceVariant,
                  ),
                  child: Icon(
                    Icons.history,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchResult result;
  final String locale;
  final VoidCallback? onServiceTap;

  const _SearchResultItem({
    required this.result,
    required this.locale,
    this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onServiceTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: result.type == SearchResultType.service
                  ? Image.asset(
                      result.getImageUrl(),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.cleaning_services,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    )
                  : CachedNetworkImage(
                      imageUrl: result.getImageUrl(),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.getTitle(locale),
                    style: AppTypography.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (result.getSubtitle(locale) != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.getSubtitle(locale)!,
                      style: AppTypography.bodySmall(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (result.type == SearchResultType.service) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${result.service!.price.toStringAsFixed(0)} د.ل',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              result.type == SearchResultType.service
                  ? Icons.cleaning_services
                  : Icons.person,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
