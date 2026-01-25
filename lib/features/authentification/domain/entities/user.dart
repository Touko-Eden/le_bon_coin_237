import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String fullName;
  final String? email;
  final String phone;
  final String role;
  final bool isVerified;
  final String? avatar;
  final String? location;
  final bool isActive;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.fullName,
    this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    this.avatar,
    this.location,
    this.isActive = true,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    role,
    isVerified,
    avatar,
    location,
    isActive,
    createdAt,
  ];
}