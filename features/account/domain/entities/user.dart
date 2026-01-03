import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String? gender;
  final String locale;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.gender,
    this.locale = 'en',
    this.createdAt,
    this.updatedAt,
  });

  static const User anonymous = User(id: 'anonymous', name: 'Guest', phone: '');

  bool get isAnonymous => id == 'anonymous';

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    String? gender,
    String? locale,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      locale: locale ?? this.locale,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    email,
    avatarUrl,
    gender,
    locale,
    createdAt,
    updatedAt,
  ];
}
