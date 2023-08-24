import 'dart:convert';

import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:dio/dio.dart';

import '../network/services/api_error.dart';

class TeamRepository {
  final ApiService apiService;

  TeamRepository({required this.apiService});

  Future<void> updateTeam(List<UpdateTeamRequest> updateTeamRequest) async {
    final body = jsonEncode(updateTeamRequest);
    try {
      await apiService.put('/api/event/team-members', body: body);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }
}
