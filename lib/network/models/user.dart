import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  late String name;
  String email;
  String? role;
  String password;
  DateTime dateOfBirth;
  String postalCode;
  String cc;
  String phone;
  String address;
  String nosCard;
  String tShirtSize;
  bool isCheckedPrivacyData;
  bool isCheckedTermsConditions;
  bool isCaptain;
  String teamId;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.postalCode,
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
