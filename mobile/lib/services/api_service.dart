import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';

  static Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> taskList = data['tasks'] ?? [];
      return taskList.map((json) => Task.fromJson(json)).toList();
    }
    throw Exception('Failed to load tasks: ${response.statusCode}');
  }

  static Future<Task> getTask(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data['task']);
    }
    throw Exception('Failed to load task: ${response.statusCode}');
  }

  static Future<Task> createTask(String title, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'description': description}),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data['task']);
    }
    throw Exception('Failed to create task: ${response.statusCode}');
  }
}
