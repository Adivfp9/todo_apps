import 'package:todo_apps/data/models/todo.dart';

class TodoResponse {
  String? message;
  List<Todo>? data;

  TodoResponse({this.message, this.data});

  TodoResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Todo>[];
      json['data'].forEach((v) {
        data!.add(Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  TodoResponse.withError(String error) : message = error;
}
