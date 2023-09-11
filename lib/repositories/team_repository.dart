import 'dart:convert';

import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:dio/dio.dart';
import '../network/services/api_error.dart';

class TeamRepository {
  final ApiService apiService;

  TeamRepository({required this.apiService});

  Future<void> updateTeam(List<UpdateTeamRequest> updateTeamRequest) async {
    final body = jsonEncode(updateTeamRequest);
    try {
      await apiService.put('/api/teams/team-flags', body: body);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  Future<void> updateTeamZones(List<Zones> updateTeamZones, String teamId) async {
    final Map<String, dynamic> zonesMap = {
      "zones": updateTeamZones.map((zone) => zone.toJson()).toList(),
    };

    final body = jsonEncode(zonesMap);
    try {
      await apiService.put('/api/teams/teams/$teamId/zones', body: body);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  Future<List<Team>> getTeams(String eventId) async {
    try {
      final response = await apiService.get('/api/teams/events/$eventId/teams');
      var eventDataList = List<Map<String, dynamic>>.from(response.data);
      var listOfTeams = eventDataList.map((eventData) => Team.fromJson(eventData)).toList();
      return listOfTeams;
    } catch (e) {
      rethrow;
    }
  }

  Future<Team> getTeamDetails(String eventId, String teamId) async {
    try {
      final response = await apiService.get('/api/teams/event/$eventId/teams/$teamId');
      var responseData = response.data as Map<String, dynamic>;
      var teamData = responseData['team'] as Map<String, dynamic>;
      return Team.fromJson(teamData);
    } catch (e) {
      rethrow;
    }
  }

  updateTeamMember(User user) async {
    try {
      final body = jsonEncode(user);
      await apiService.put('/api/teams/users/${user.id}', body: body);
    } catch (e) {
      rethrow;
    }
  }

  deleteTeamMember(String teamId, String userId) async {
    try {
      await apiService.delete('/api/teams/$teamId/users/$userId');
    } catch (e) {
      rethrow;
    }
  }

  addTeamMember(String teamId, User user) async {
    try {
      final body = jsonEncode(user);
      await apiService.post('/api/teams/$teamId/add-users', body: body);
    } catch (e) {
      rethrow;
    }
  }

  deleteTeam(String teamId, String userId) async {
    try {
      await apiService.get('/api/teams/$teamId/users/$userId');
    } catch (e) {
      rethrow;
    }
  }
}
