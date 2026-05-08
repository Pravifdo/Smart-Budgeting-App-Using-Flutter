import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api";

  // Register user
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User registered successfully',
          'data': jsonDecode(response.body),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Login successful',
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Add expense
  static Future<Map<String, dynamic>> addExpense({
    required String token,
    required String title,
    required double amount,
    required String category,
    required String date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/expenses/add"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "amount": amount,
          "category": category,
          "date": date,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Expense added successfully',
          'data': jsonDecode(response.body),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to add expense',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get all expenses
  static Future<Map<String, dynamic>> getExpenses({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/expenses/all"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch expenses'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> addSalary({
    required String userId,
    required double previousBalance,
    required double salary,
    required double totalExpenses,
    required String month,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/balance/add-salary"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "userId": userId,
          "previousBalance": previousBalance,
          "salary": salary,
          "totalExpenses": totalExpenses,
          "month": month,
        }),
      );

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // GET LATEST BALANCE
  static Future<Map<String, dynamic>> getLatestBalance(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/balance/latest/$userId"),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
