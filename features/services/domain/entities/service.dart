import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String iconUrl;
  final String? descriptionAr;
  final String? descriptionEn;
  final double price;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Service({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    this.descriptionAr,
    this.descriptionEn,
    required this.price,
    required this.displayOrder,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  static Service empty = Service(
    id: '',
    nameAr: '',
    nameEn: '',
    iconUrl: '',
    displayOrder: 0,
    createdAt: DateTime.now(),
    price: 0,
  );

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
    price,
    displayOrder,
    isActive,
    createdAt,
    updatedAt,
  ];
}
