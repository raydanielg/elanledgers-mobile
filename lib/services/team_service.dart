// services/team_service.dart
import 'api_service.dart';

class TeamService {
  final ApiService _api = ApiService();

  // Get team members
  Future<Map<String, dynamic>> getTeam() async {
    try {
      final response = await _api.get('/app/get/getdata/team');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get waiters
  Future<Map<String, dynamic>> getWaiters() async {
    try {
      final response = await _api.get('/app/get/getdata/waiters');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get all users
  Future<Map<String, dynamic>> getUsers() async {
    try {
      final response = await _api.get('/app/get/getdata/users');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get staff in sales
  Future<Map<String, dynamic>> getStaffInSales() async {
    try {
      final response = await _api.get('/app/get/getdata/staffInSales');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get permissions
  Future<Map<String, dynamic>> getPermissions() async {
    try {
      final response = await _api.get('/app/get/getdata/permissions');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create waiter
  Future<Map<String, dynamic>> createWaiter(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/waiter/create', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add staff member
  Future<Map<String, dynamic>> addStaff(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/staff/add', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add non-staff member
  Future<Map<String, dynamic>> addNonStaff(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/nonstaff/add', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update team member
  Future<Map<String, dynamic>> updateMember(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/member/update', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update team status
  Future<Map<String, dynamic>> updateStatus(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/status/update', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update permission
  Future<Map<String, dynamic>> updatePermission(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/team/permission/update', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
