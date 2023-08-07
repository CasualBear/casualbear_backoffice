import 'dart:convert';

import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/services/api_error.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:dio/dio.dart';

class QuestionRepository {
  final ApiService apiService;

  QuestionRepository({required this.apiService});

  Future<void> addQuestion(Question question, String eventId) async {
    try {
      await apiService.post('/api/event/events/$eventId/questions', body: question);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  Future<void> updateQuestion(Question question, String eventId) async {
    try {
      final body = jsonEncode(question.toJson());
      await apiService.put('/api/event/questions/${question.id}', body: body);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  deleteQuestion(String eventId) async {
    try {
      await apiService.delete('/api/event/questions/$eventId');
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }
}
