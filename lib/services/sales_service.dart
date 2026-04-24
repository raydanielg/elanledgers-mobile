// services/sales_service.dart
import 'api_service.dart';

class SalesService {
  final ApiService _api = ApiService();

  // Get all sales
  Future<Map<String, dynamic>> getSales() async {
    try {
      final response = await _api.get('/app/get/getdata/sales');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get orders
  Future<Map<String, dynamic>> getOrders() async {
    try {
      final response = await _api.get('/app/get/getdata/orders');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get sales orders
  Future<Map<String, dynamic>> getSalesOrders() async {
    try {
      final response = await _api.get('/app/get/getdata/sales_orders');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get invoices
  Future<Map<String, dynamic>> getInvoices() async {
    try {
      final response = await _api.get('/app/get/getdata/invoices');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get sales summary
  Future<Map<String, dynamic>> getSalesSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/sales_summary');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get invoice summary
  Future<Map<String, dynamic>> getInvoiceSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/invoice_summary');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get order summary
  Future<Map<String, dynamic>> getOrderSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/order_summary');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create sale
  Future<Map<String, dynamic>> createSale(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/sales/add', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add payment to invoice
  Future<Map<String, dynamic>> addPayment(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/sales/add-payment', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
