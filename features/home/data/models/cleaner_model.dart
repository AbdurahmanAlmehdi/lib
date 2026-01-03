import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class CleanerModel extends Cleaner {
  const CleanerModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.rating,
    required super.reviewsCount,
    required super.serviceIds,
    required super.completedJobs,
    required super.joinedDate,
    super.bioAr,
    super.bioEn,
  });

  factory CleanerModel.fromJson(Map<String, dynamic> json) {
    List<String> serviceIds = [];
    if (json['cleaner_services'] != null) {
      serviceIds = (json['cleaner_services'] as List<dynamic>)
          .map((e) => e['service_id'] as String)
          .toList();
    } else if (json['service_ids'] != null) {
      serviceIds = (json['service_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    }

    return CleanerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      serviceIds: serviceIds,
      completedJobs: json['completed_jobs'] as int? ?? 0,
      joinedDate: json['joined_date'] != null
          ? DateTime.parse(json['joined_date'] as String)
          : DateTime.now(),
      bioAr: json['bio_ar'] as String?,
      bioEn: json['bio_en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'rating': rating,
      'reviews_count': reviewsCount,
      'service_ids': serviceIds,
      'completed_jobs': completedJobs,
      'joined_date': joinedDate.toIso8601String(),
      'bio_ar': bioAr,
      'bio_en': bioEn,
    };
  }
}
