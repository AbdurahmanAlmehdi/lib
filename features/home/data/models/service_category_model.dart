import 'package:buzzy_bee/features/home/domain/entities/service_category.dart';

class ServiceCategoryModel extends ServiceCategory {
  const ServiceCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.iconUrl,
    super.descriptionAr,
    super.descriptionEn,
    required super.displayOrder,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      iconUrl: json['icon_url'] as String,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'icon_url': iconUrl,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'display_order': displayOrder,
    };
  }
}
