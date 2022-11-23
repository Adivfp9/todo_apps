import 'package:flutter/material.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/repository/api_services.dart';
import 'package:todo_apps/data/repository/responses/todo_response.dart';

final ApiServices _apiService = ApiServices();

class TodoProvider extends ChangeNotifier {
  bool? isLoading = false;
  bool? isDone;
  List<Todo> todoList = [];
  TodoProvider() {
    getTodoList();
  }

  getTodoList() async {
    isLoading = true;
    todoList.clear();
    TodoResponse? response = await _apiService.getTodo();
    List<Todo>? todos = response!.data;
    todoList.addAll(todos!);
    isLoading = false;
    notifyListeners();
  }

  void setDone(bool value) {
    debugPrint('$value');
    notifyListeners();
  }
}
