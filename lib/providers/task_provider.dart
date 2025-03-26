import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _stats;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get stats => _stats;

  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      _tasks = await _taskService.getAllTasks();
      _calculateStats();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Task?> getTaskById(String id) async {
    try {
      return await _taskService.getTaskById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  Future<void> createTask(Task task) async {
    _setLoading(true);
    try {
      await _taskService.createTask(task);
      await fetchTasks(); // Refresh the list
      _error = null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> updateTask(String id, Task task) async {
    _setLoading(true);
    try {
      await _taskService.updateTask(id, task);
      await fetchTasks(); // Refresh the list
      _error = null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String id) async {
    _setLoading(true);
    try {
      await _taskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      _calculateStats();
      notifyListeners();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _calculateStats() {
    _stats = _taskService.calculateTaskStats(_tasks);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}