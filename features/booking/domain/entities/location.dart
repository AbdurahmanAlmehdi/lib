import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String address;
  final double latitude;
  final double longitude;
  final String? buildingNumber;
  final String? apartmentNumber;
  final String? notes;
  final bool isDefault;

  const Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.buildingNumber,
    this.apartmentNumber,
    this.notes,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
        id,
        address,
        latitude,
        longitude,
        buildingNumber,
        apartmentNumber,
        notes,
        isDefault,
      ];
}

