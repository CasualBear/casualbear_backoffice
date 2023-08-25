// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      password: json['password'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      cc: json['cc'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      nosCard: json['nosCard'] as String,
      tShirtSize: json['tShirtSize'] as String,
      isCheckedPrivacyData: json['isCheckedPrivacyData'] as bool,
      isCheckedTermsConditions: json['isCheckedTermsConditions'] as bool,
      isCheckedOverall: json['isCheckedOverall'] as bool,
      isVerified: json['isVerified'] as bool,
      isCheckedIn: json['isCheckedIn'] as bool,
      isCaptain: json['isCaptain'] as bool,
      teamId: json['teamId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'password': instance.password,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'cc': instance.cc,
      'phone': instance.phone,
      'address': instance.address,
      'nosCard': instance.nosCard,
      'tShirtSize': instance.tShirtSize,
      'isCheckedPrivacyData': instance.isCheckedPrivacyData,
      'isCheckedTermsConditions': instance.isCheckedTermsConditions,
      'isCheckedOverall': instance.isCheckedOverall,
      'isVerified': instance.isVerified,
      'isCheckedIn': instance.isCheckedIn,
      'isCaptain': instance.isCaptain,
      'teamId': instance.teamId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
