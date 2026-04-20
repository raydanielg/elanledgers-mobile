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

      // Check if API returned success status
      final bool isSuccess = data['status'] == true || data['statusCode'] == 200;
      
      if (isSuccess) {
        // Save token if provided
        if (data is Map && data.containsKey('token') && data['token'] != null) {
          await _api.saveToken(data['token']);
        }

        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
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

      // Check if API returned success status
      final bool isSuccess = data['status'] == true || data['statusCode'] == 200;
      
      if (isSuccess) {
        // Save token if provided
        if (data is Map && data.containsKey('token') && data['token'] != null) {
          await _api.saveToken(data['token']);
        }

        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
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

      // Check if API returned success status
      final bool isSuccess = data['status'] == true || data['statusCode'] == 200;
      
      return {
        'success': isSuccess,
        'data': data,
        'message': data['message'] ?? (isSuccess ? 'Reset link sent successfully' : 'Failed to send reset link'),
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
