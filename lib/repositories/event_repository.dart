import 'dart:convert';

import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import '../network/services/api_error.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository(this.apiService);

  createEvent(List<int> selectedFile, String name, String description, String color) async {
    try {
      var url = Uri.parse("https://casuabearapi.herokuapp.com/api/event/upload-event");
      var request = http.MultipartRequest("POST", url);
      request.files.add(await http.MultipartFile.fromBytes('iconFile', selectedFile,
          contentType: MediaType('application', 'json'), filename: "icon"));

      request.fields['name'] = name; // Add name field
      request.fields['description'] = description;
      request.fields['selectedColor'] = color;
      await request.send();
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  updateEvent(List<int> selectedFile, String name, String description, String color, String eventId) async {
    try {
      var url = Uri.parse("https://casuabearapi.herokuapp.com/api/event/events/$eventId");
      var request = http.MultipartRequest("PUT", url);
      request.files.add(await http.MultipartFile.fromBytes('iconFile', selectedFile,
          contentType: MediaType('application', 'json'), filename: "icon"));

      request.fields['name'] = name; // Add name field
      request.fields['description'] = description;
      request.fields['selectedColor'] = color;
      await request.send();
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      final response = await apiService.get('/api/event/events');
      var eventDataList = List<dynamic>.from(response.data['events']);
      var listOfEvents = eventDataList.map((eventData) => Event.fromJson(eventData as Map<String, dynamic>)).toList();
      return listOfEvents;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Event> getEvent(String id) async {
    try {
      final response = await apiService.get('/api/event/events/$id');
      var eventData = response.data['event'];
      var event = Event.fromJson(eventData as Map<String, dynamic>);
      return event;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  deleteEvent(String eventId) async {
    try {
      await apiService.delete('/api/event/events/$eventId');
    } catch (e) {
      print(e);
    }
  }

// Questions

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

  // Zones

  Future<void> updateZoneState(String eventId, String zoneNameToUpdate, bool status) async {
    try {
      final request = {"state": status ? "active" : "inactive"};
      final body = jsonEncode(request);
      await apiService.put('/api/event/events/$eventId/zones/$zoneNameToUpdate', body: body);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiError.fromJson(e.response!.data['error']);
      } else {
        rethrow;
      }
    }
  }

  // Teams

  Future<List<TeamMember>> getUsersByTeam(String teamId) async {
    try {
      final response = await apiService.get('/api/event/team-members/$teamId');
      List<dynamic> responseData = response.data;
      var teamMembers =
          responseData.map((teamMemberdata) => TeamMember.fromJson(teamMemberdata as Map<String, dynamic>)).toList();
      return teamMembers;
    } catch (e) {
      rethrow;
    }
  }
}
