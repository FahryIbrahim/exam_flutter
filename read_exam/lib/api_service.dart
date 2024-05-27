import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee.dart';

class ApiService {
  static const String apiUrl = 'https://dummy.restapiexample.com/api/v1/employees';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
}
