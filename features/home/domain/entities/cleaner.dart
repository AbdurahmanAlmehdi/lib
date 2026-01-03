import 'package:equatable/equatable.dart';

class Cleaner extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final int reviewsCount;
  final List<String> serviceIds;
  final int completedJobs;
  final DateTime joinedDate;
  final String? bioAr;
  final String? bioEn;

  const Cleaner({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.reviewsCount,
    required this.serviceIds,
    required this.completedJobs,
    required this.joinedDate,
    this.bioAr,
    this.bioEn,
  });

  static Cleaner empty = Cleaner(
    id: '',
    name: '',
    avatarUrl: '',
    rating: 0,
    reviewsCount: 0,
    serviceIds: [],
    completedJobs: 0,
    joinedDate: DateTime.now(),
  );

  String? getBio(String locale) {
    return locale == 'ar' ? bioAr : bioEn;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    avatarUrl,
    rating,
    reviewsCount,
    serviceIds,
    completedJobs,
    joinedDate,
    bioAr,
    bioEn,
  ];
}
