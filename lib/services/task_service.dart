import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  static const String _baseUrl = 'http://localhost:5000/api';
  final http.Client _client = http.Client();

  Future<List<Task>> getAllTasks() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/tasks'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch tasks');
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<Task> getTaskById(String id) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/tasks/$id'));
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to fetch task');
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to create task');
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  Future<Task> updateTask(String id, Task task) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to update task');
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await _client.delete(Uri.parse('$_baseUrl/tasks/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  Map<String, dynamic> calculateTaskStats(List<Task> tasks) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final tasksThisMonth = tasks.where((task) => 
      DateTime.parse(task.date).isAfter(currentMonth)).length;

    final tasksLastMonth = tasks.where((task) => 
      DateTime.parse(task.date).isAfter(lastMonth) && 
      DateTime.parse(task.date).isBefore(currentMonth)).length;

    final tasksLast30Days = tasks.where((task) => 
      DateTime.parse(task.date).isAfter(thirtyDaysAgo)).length;

    final monthlyChange = tasksLastMonth == 0
        ? 100.0
        : ((tasksThisMonth - tasksLastMonth) / tasksLastMonth) * 100;

    return {
      'totalTasks': tasks.length,
      'tasksThisMonth': tasksThisMonth,
      'tasksLast30Days': tasksLast30Days,
      'monthlyChange': monthlyChange,
    };
  }
}