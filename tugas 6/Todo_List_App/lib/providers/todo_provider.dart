import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

enum TodoFilter { all, completed, incomplete }

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;
  bool _isLoading = false;

  List<Todo> get todos {
    switch (_currentFilter) {
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.incomplete:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return List.from(_todos);
    }
  }

  TodoFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get incompleteCount => _todos.where((todo) => !todo.isCompleted).length;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _todoService.loadTodos();
    } catch (e) {
      print('Error loading todos: $e');
      _todos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title, String description) async {
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    _todos.add(newTodo);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> toggleTodoStatus(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> clearCompleted() async {
    _todos.removeWhere((todo) => todo.isCompleted);
    await _saveTodos();
    notifyListeners();
  }

  void setFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    await _todoService.saveTodos(_todos);
  }
}
