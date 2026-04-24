// services/profit_expense_service.dart
import 'api_service.dart';

class ProfitExpenseService {
  final ApiService _api = ApiService();

  // Get profit summary
  Future<Map<String, dynamic>> getProfitSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/profit_summary');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get expense summary
  Future<Map<String, dynamic>> getExpenseSummary() async {
    try {
      final response = await _api.get('/app/get/getdata/expense_summary');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get expense accounts
  Future<Map<String, dynamic>> getExpenseAccounts() async {
    try {
      final response = await _api.get('/app/get/getdata/expense_accounts');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get cashflow
  Future<Map<String, dynamic>> getCashflow() async {
    try {
      final response = await _api.get('/app/get/getdata/cashflow');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get expenses
  Future<Map<String, dynamic>> getExpenses() async {
    try {
      final response = await _api.get('/app/get/getdata/expenses');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add expense
  Future<Map<String, dynamic>> addExpense(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/cashflow/add-expense', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add fund/cash in
  Future<Map<String, dynamic>> addFund(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/cashflow/add-fund', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete expenses
  Future<Map<String, dynamic>> deleteExpenses(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/app/post/postdata/cashflow/delete-expenses', data: data);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get cashbook accounts
  Future<Map<String, dynamic>> getCashbookAccounts() async {
    try {
      final response = await _api.get('/app/get/getdata/cashbookAccounts');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get chart of accounts
  Future<Map<String, dynamic>> getChartOfAccounts() async {
    try {
      final response = await _api.get('/app/get/getdata/chatOfAccounts');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get source of fund accounts
  Future<Map<String, dynamic>> getSourceOfFundAccounts() async {
    try {
      final response = await _api.get('/app/get/getdata/sourceOfFundAccounts');
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
