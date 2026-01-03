import 'package:buzzy_bee/features/home/domain/entities/ad_banner.dart';

class AdBannerModel extends AdBanner {
  const AdBannerModel({
    required super.id,
    required super.imageUrl,
    super.actionUrl,
    super.actionType,
    super.actionId,
    required super.priority,
    super.expiresAt,
  });

  factory AdBannerModel.fromJson(Map<String, dynamic> json) {
    return AdBannerModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      actionUrl: json['action_url'] as String?,
      actionType: json['action_type'] as String?,
      actionId: json['action_id'] as String?,
      priority: json['priority'] as int? ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'action_type': actionType,
      'action_id': actionId,
      'priority': priority,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
