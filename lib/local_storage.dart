// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void saveToken(String token) {
  html.window.localStorage['token'] = token;
}

String? getToken() {
  return html.window.localStorage['token'];
}

void removeToken() {
  html.window.localStorage.remove('token');
}

void saveGameStartTime(DateTime startTime) {
  html.window.localStorage['gameStartTime'] = startTime.toIso8601String();
}

DateTime? getGameStartTime() {
  final String? startTimeString = html.window.localStorage['gameStartTime'];
  if (startTimeString == null) return null;
  return DateTime.parse(startTimeString);
}

void removeGameStartTime() {
  html.window.localStorage.remove('gameStartTime');
}

void saveTeamId(int teamId) {
  html.window.localStorage['teamId'] = teamId.toString();
}

int? getTeamId() {
  final String? teamIdString = html.window.localStorage['teamId'];
  if (teamIdString == null) return null;
  return int.parse(teamIdString);
}

void removeTeamId() {
  html.window.localStorage.remove('teamId');
}
