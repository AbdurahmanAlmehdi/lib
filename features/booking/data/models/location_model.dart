import 'package:buzzy_bee/features/booking/domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.id,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.buildingNumber,
    super.apartmentNumber,
    super.notes,
    super.isDefault,
  });

  factory LocationModel.fromEntity(Location entity) {
    if (entity is LocationModel) {
      return entity;
    }
    return LocationModel(
      id: entity.id,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      buildingNumber: entity.buildingNumber,
      apartmentNumber: entity.apartmentNumber,
      notes: entity.notes,
      isDefault: entity.isDefault,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String? ?? '',
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      buildingNumber: json['building_number'] as String?,
      apartmentNumber: json['apartment_number'] as String?,
      notes: json['notes'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'building_number': buildingNumber,
      'apartment_number': apartmentNumber,
      'notes': notes,
      'is_default': isDefault,
    };
  }
}

