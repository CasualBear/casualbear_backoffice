import 'dart:convert';
import 'package:casualbear_backoffice/network/services/api_service.dart';

class AuthenticationRepository {
  final ApiService apiService;

  AuthenticationRepository(this.apiService);

  Future<String> login(String username, String password, String deviceId) async {
    try {
      final body = jsonEncode({'email': username, 'password': password, 'deviceIdentifier': deviceId});
      final response = await apiService.post('/api/user/login', body: body);
      final String role = response.data['role'];
      if (role == "ADMIN") {
        return role;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
