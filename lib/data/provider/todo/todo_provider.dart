import 'package:flutter/material.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/repository/api_services.dart';
import 'package:todo_apps/data/repository/responses/todo_response.dart';

final ApiServices _apiService = ApiServices();

class TodoProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isLoading = false;
  bool? isCheckDone;
  List<Todo> todoList = [];
  List<Todo> subTodoList = [];
  String todoTitle = '';
  DateTime? todoStartDate, todoDueDate;
  TextEditingController? titleCtrl = TextEditingController();

  TodoProvider() {
    getTodoList();
    notifyListeners();
  }

  getTodoList() async {
    isLoading = true;
    todoList.clear();
    subTodoList.clear();
    TodoResponse? response = await _apiService.getTodo();
    List<Todo>? todos = response!.data;

    Iterable<Todo> parentTodo =
        todos!.where((element) => element.parentId == null);
    Iterable<Todo> childTodo =
        todos.where((element) => element.parentId != null);

    todoList.addAll(parentTodo);
    subTodoList.addAll(childTodo);
    isLoading = false;
    notifyListeners();
  }

  void setDone(bool value) {
    isCheckDone = value;
    notifyListeners();
  }

  void setTitle(String value) {
    todoTitle = value;
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    todoStartDate = value;
    notifyListeners();
  }

  void setDueDate(DateTime value) {
    todoDueDate = value;
    notifyListeners();
  }

  bool validateInput() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<String?> addTodo(Todo data) async {
    return await _apiService.addPostTodo(data.toJson());
  }

  Future<String?> updateTodo(Todo data) async {
    return await _apiService.updateTodoData(data.toJson());
  }

  Future<String?> deleteData(int id) async {
    return await _apiService.deleteTodoData(id);
  }
}
