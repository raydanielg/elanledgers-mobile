// services/stock_service.dart
import 'api_service.dart';

class StockService {
  final ApiService _api = ApiService();

  // Get all products
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _api.get('/app/get/getdata/products');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get stock data
  Future<Map<String, dynamic>> getStock() async {
    try {
      final response = await _api.get('/app/get/getdata/stock');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get stock categories
  Future<Map<String, dynamic>> getStockCategories() async {
    try {
      final response = await _api.get('/app/get/getdata/stock_category');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get sellable stock
  Future<Map<String, dynamic>> getSellableStock() async {
    try {
      final response = await _api.get('/app/get/getdata/sellable_stock');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get stock category wise
  Future<Map<String, dynamic>> getStockCategoryWise() async {
    try {
      final response = await _api.get('/app/get/getdata/stockCategoryWise');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get product history
  Future<Map<String, dynamic>> getProductHistory() async {
    try {
      final response = await _api.get('/app/get/getdata/product_history');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get live inventory
  Future<Map<String, dynamic>> getLiveInventory() async {
    try {
      final response = await _api.get('/app/get/getdata/stock/inventory');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create product
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/stock/register/create', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Restock product
  Future<Map<String, dynamic>> restockProduct(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/stock/restock/create', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update product
  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/stock/product/update', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
