import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        ApiService.authSignin,
        data: {
          'username': username,
          'password': password,
        },
      );

      final data = response.data;

      // Save token if provided
      if (data is Map && data.containsKey('token')) {
        await _api.saveToken(data['token']);
      }

      return {
        'success': true,
        'data': data,
        'message': data['message'] ?? 'Login successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String shopName,
    required String phone,
    required String email,
    required String password,
    String? region,
  }) async {
    try {
      final response = await _api.post(
        ApiService.authRegister,
        data: {
          'fullname': fullName,
          'shop_name': shopName,
          'phone': phone,
          'email': email,
          'password': password,
          'region': region ?? '',
        },
      );

      final data = response.data;

      // Save token if provided
      if (data is Map && data.containsKey('token')) {
        await _api.saveToken(data['token']);
      }

      return {
        'success': true,
        'data': data,
        'message': data['message'] ?? 'Registration successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Send Reset Password Link
  Future<Map<String, dynamic>> sendResetLink({
    required String username,
  }) async {
    try {
      final response = await _api.post(
        ApiService.authResetSend,
        data: {
          'username': username,
        },
      );

      final data = response.data;

      return {
        'success': true,
        'data': data,
        'message': data['message'] ?? 'Reset link sent successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _api.clearToken();
  }

  // Check if user is logged in
  bool get isLoggedIn => _api.isAuthenticated;
}
