// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionRequest _$QuestionRequestFromJson(Map<String, dynamic> json) =>
    QuestionRequest(
      id: json['id'] as int,
      question: json['question'] as String,
      isVisible: json['isVisible'] as bool,
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      points: json['points'] as int,
      zone: json['zone'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      eventId: json['eventId'] as int,
    );

Map<String, dynamic> _$QuestionRequestToJson(QuestionRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answers': instance.answers,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'isVisible': instance.isVisible,
      'points': instance.points,
      'zone': instance.zone,
      'latitude': instance.latitude,
      'imageUrl': instance.imageUrl,
      'longitude': instance.longitude,
      'address': instance.address,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'eventId': instance.eventId,
    };
