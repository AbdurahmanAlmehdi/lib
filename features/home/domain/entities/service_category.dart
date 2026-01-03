import 'package:equatable/equatable.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String iconUrl;
  final String? descriptionAr;
  final String? descriptionEn;
  final int displayOrder;

  const ServiceCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    this.descriptionAr,
    this.descriptionEn,
    required this.displayOrder,
  });

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  String? getDescription(String locale) {
    return locale == 'ar' ? descriptionAr : descriptionEn;
  }

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    iconUrl,
    descriptionAr,
    descriptionEn,
    displayOrder,
  ];
}
