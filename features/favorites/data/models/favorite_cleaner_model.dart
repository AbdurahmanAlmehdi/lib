import 'package:buzzy_bee/features/favorites/domain/entities/favorite_cleaner.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

class FavoriteCleanerModel extends FavoriteCleaner {
  const FavoriteCleanerModel({required super.cleaner});

  factory FavoriteCleanerModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCleanerModel(
      cleaner: CleanerModel.fromJson(json['cleaner'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'cleaner': (cleaner as CleanerModel).toJson(), 'price': 0};
  }
}
