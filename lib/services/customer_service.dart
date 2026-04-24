// services/customer_service.dart
import 'api_service.dart';

class CustomerService {
  final ApiService _api = ApiService();

  // Get all customers
  Future<Map<String, dynamic>> getCustomers() async {
    try {
      final response = await _api.get('/app/get/getdata/customers');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get all contacts
  Future<Map<String, dynamic>> getContacts() async {
    try {
      final response = await _api.get('/app/get/getdata/contacts');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get on-credit customers
  Future<Map<String, dynamic>> getOnCreditCustomers() async {
    try {
      final response = await _api.get('/app/get/getdata/oncredit_customers');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get customer categories
  Future<Map<String, dynamic>> getContactCategories() async {
    try {
      final response = await _api.get('/app/get/getdata/contact_category');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create customer
  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/customer/create', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete customer
  Future<Map<String, dynamic>> deleteCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/customer/delete', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Import customers
  Future<Map<String, dynamic>> importCustomers(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/customer/import', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create contact category
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/customer/category/create', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Send bulk SMS
  Future<Map<String, dynamic>> sendBulkSMS(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/customer/sms/send-bulk', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get customers in sales
  Future<Map<String, dynamic>> getCustomerInSales() async {
    try {
      final response = await _api.get('/app/get/getdata/customerInSales');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
