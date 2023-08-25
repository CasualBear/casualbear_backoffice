import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String password;
  final DateTime dateOfBirth;
  final String cc;
  final String phone;
  final String address;
  final String nosCard;
  final String tShirtSize;
  final bool isCheckedPrivacyData;
  final bool isCheckedTermsConditions;
  final bool isCaptain;
  final String teamId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    required this.password,
    required this.dateOfBirth,
    required this.cc,
    required this.phone,
    required this.address,
    required this.nosCard,
    required this.tShirtSize,
    required this.isCheckedPrivacyData,
    required this.isCheckedTermsConditions,
    required this.isCaptain,
    required this.teamId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
