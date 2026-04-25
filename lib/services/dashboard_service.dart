// services/dashboard_service.dart
import 'api_service.dart';

class DashboardService {
  final ApiService _api = ApiService();

  // Get dashboard summary data
  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/dashboard_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get session user info
  Future<Map<String, dynamic>> getSessionUser() async {
    try {
      final response = await _api.get('/app/get/getdata/session_user');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get session shop info
  Future<Map<String, dynamic>> getSessionShop() async {
    try {
      final response = await _api.get('/app/get/getdata/session_shop');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get all shops
  Future<Map<String, dynamic>> getMyShops() async {
    try {
      final response = await _api.get('/app/get/getdata/my_shops');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get shops count
  Future<Map<String, dynamic>> getShops() async {
    try {
      final response = await _api.get('/app/get/getdata/shops');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get team members count
  Future<Map<String, dynamic>> getTeam() async {
    try {
      final response = await _api.get('/app/get/getdata/team');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get customers count
  Future<Map<String, dynamic>> getCustomers() async {
    try {
      final response = await _api.get('/app/get/getdata/customers');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get suppliers count
  Future<Map<String, dynamic>> getSuppliers() async {
    try {
      final response = await _api.get('/app/get/getdata/suppliers');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get products count
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _api.get('/app/get/getdata/products');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get stock data
  Future<Map<String, dynamic>> getStock() async {
    try {
      final response = await _api.get('/app/get/getdata/stock');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get sales data
  Future<Map<String, dynamic>> getSales() async {
    try {
      final response = await _api.get('/app/get/getdata/sales');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get sales summary
  Future<Map<String, dynamic>> getSalesSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/sales_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get invoice summary
  Future<Map<String, dynamic>> getInvoiceSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/invoice_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get order summary
  Future<Map<String, dynamic>> getOrderSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/order_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get profit summary
  Future<Map<String, dynamic>> getProfitSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/profit_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get expense summary
  Future<Map<String, dynamic>> getExpenseSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/expense_summary');
      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Switch shop
  Future<Map<String, dynamic>> switchShop(String shopId) async {
    try {
      final response = await _api.post(
        '/app/auth/switchshop',
        data: {'shop_id': shopId},
      );
      return {
        'success': true,
        'data': response.data,
        'message': 'Shop switched successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Add new shop
  Future<Map<String, dynamic>> addShop({
    required String shopName,
    String? shopType,
    String? category,
    String? region,
  }) async {
    try {
      final response = await _api.post(
        '/app/auth/addshop',
        data: {
          'shop_name': shopName,
          'shop_type': shopType ?? 'Both Product and Service',
          'category': category ?? 'Uncategorized',
          'region': region ?? '',
        },
      );
      return {
        'success': true,
        'data': response.data,
        'message': 'Shop added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
