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
      final bool isSuccess = data['status'] == true || data['statusCode'] == 200 || data['statusCode'] == 201;
      
      if (isSuccess) {
        // Extract token - could be in root or in result object
        String? token = data['token'];
        if (token == null && data['result'] is Map) {
          token = data['result']['token'];
        }
        
        // Save token if found
        if (token != null && token.isNotEmpty && token != 'null') {
          print('Token found: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
          await _api.saveToken(token);
        } else {
          print('WARNING: No token found in response!');
          print('Response keys: ${data.keys.toList()}');
        }

        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? data['result']?['message'] ?? 'Login successful',
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
    required String username,
    required String shopName,
    required String phone,
    required String email,
    required String password,
    String? confirmPassword,
    String? region,
    String? country,
  }) async {
    try {
      final response = await _api.post(
        ApiService.authRegister,
        data: {
          'username': username,
          'shop_name': shopName,
          'phone': phone,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword ?? password,
          'region': region ?? '',
          'country': country ?? 'Tanzania',
        },
      );

      final data = response.data;

      // Check if API returned success status
      final bool isSuccess = data['status'] == true || data['statusCode'] == 200 || data['statusCode'] == 201;
      
      if (isSuccess) {
        // Extract token - could be in root or in result object
        String? token = data['token'];
        if (token == null && data['result'] is Map) {
          token = data['result']['token'];
        }
        
        // Save token if found
        if (token != null && token.isNotEmpty && token != 'null') {
          await _api.saveToken(token);
        }

        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? data['result']?['message'] ?? 'Registration successful',
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
