import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/widgets/error_view.dart';
import 'package:buzzy_bee/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:buzzy_bee/features/favorites/presentation/widgets/favorite_cleaner_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.favorites,
          style: AppTypography.titleLarge(context),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading &&
              state.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FavoritesStatus.error &&
              state.favorites.isEmpty) {
            return ErrorView(
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<FavoritesBloc>().add(
                  const FavoritesLoadRequested(),
                );
              },
            );
          }

          if (state.favorites.isEmpty) {
            return Center(
              child: Text(
                context.t.noFavorites,
                style: AppTypography.bodyLarge(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(const FavoritesLoadRequested());
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final favorite = state.favorites[index];
                      return FavoriteCleanerCard(
                        favoriteCleaner: favorite,
                        onTap: () {
                          // TODO: Navigate to cleaner details
                        },
                        onUnfavoriteTap: () {
                          context.read<FavoritesBloc>().add(
                            FavoriteRemoved(favorite.cleaner.id),
                          );
                        },
                      );
                    }, childCount: state.favorites.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
