import 'package:buzzy_bee/features/favorites/data/models/favorite_cleaner_model.dart';
import 'package:buzzy_bee/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';
import 'package:buzzy_bee/features/home/presentation/widgets/cleaner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CleanerList extends StatelessWidget {
  final List<Cleaner> cleaners;
  final bool isLoading;
  const CleanerList({
    required this.cleaners,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favoritesState) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final cleaner = isLoading ? Cleaner.empty : cleaners[index];
            final isFavorite = favoritesState.favorites.any(
              (fav) => fav.cleaner.id == cleaner.id,
            );
            return Skeletonizer(
              enabled: isLoading,
              child: CleanerCard(
                cleaner: cleaner,
                isFavorite: isFavorite,
                onTap: () {
                  // TODO: Navigate to cleaner detail
                },
                onFavoriteTap: () {
                  if (isFavorite) {
                    // Remove from favorites
                    context.read<FavoritesBloc>().add(
                      FavoriteRemoved(cleaner.id),
                    );
                  } else {
                    final favoriteCleaner = FavoriteCleanerModel(
                      cleaner: cleaner,
                    );
                    context.read<FavoritesBloc>().add(
                      FavoriteAdded(favoriteCleaner),
                    );
                  }
                },
              ),
            );
          }, childCount: isLoading ? 4 : cleaners.length),
        );
      },
    );
  }
}
