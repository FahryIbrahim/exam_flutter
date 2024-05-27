import 'package:flutter/material.dart';
import 'package:update_delete_exam/services/todo_service.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  TodoProvider() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    _todos = await _apiService.fetchTodos();
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    await _apiService.updateTodo(todo);
    int index = _todos.indexWhere((element) => element.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    await _apiService.deleteTodo(id);
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    todo.completed = !todo.completed;
    await updateTodo(todo);
  }
}
