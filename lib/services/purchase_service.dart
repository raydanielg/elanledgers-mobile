// services/purchase_service.dart
import 'api_service.dart';

class PurchaseService {
  final ApiService _api = ApiService();

  // Get purchase orders
  Future<Map<String, dynamic>> getPurchaseOrders() async {
    try {
      final response = await _api.get('/app/get/getdata/purchase_orders');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get purchase history
  Future<Map<String, dynamic>> getPurchaseHistory() async {
    try {
      final response = await _api.get('/app/get/getdata/purchase_history');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get suppliers
  Future<Map<String, dynamic>> getSuppliers() async {
    try {
      final response = await _api.get('/app/get/getdata/suppliers');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get on-credit suppliers
  Future<Map<String, dynamic>> getOnCreditSuppliers() async {
    try {
      final response = await _api.get('/app/get/getdata/oncredit_suppliers');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get on-cash suppliers
  Future<Map<String, dynamic>> getOnCashSuppliers() async {
    try {
      final response = await _api.get('/app/get/getdata/oncash_suppliers');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add supplier
  Future<Map<String, dynamic>> addSupplier(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/supplier/add', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete supplier
  Future<Map<String, dynamic>> deleteSupplier(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/supplier/delete', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete purchase
  Future<Map<String, dynamic>> deletePurchase(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/stock/purchase/delete', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
