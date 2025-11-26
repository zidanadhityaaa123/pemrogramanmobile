import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  static const String _todosKey = 'todos';

  // Save todos to SharedPreferences
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = todos.map((todo) => todo.toJson()).toList();
    await prefs.setString(_todosKey, jsonEncode(todosJson));
  }

  // Load todos from SharedPreferences
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString(_todosKey);

    if (todosString == null || todosString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> todosJson = jsonDecode(todosString);
      return todosJson.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }

  // Clear all todos
  Future<void> clearAllTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_todosKey);
  }
}