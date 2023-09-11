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
