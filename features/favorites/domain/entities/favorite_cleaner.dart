import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class FavoriteCleaner extends Equatable {
  final Cleaner cleaner;

  const FavoriteCleaner({required this.cleaner});

  @override
  List<Object?> get props => [cleaner];
}
