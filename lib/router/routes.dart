import 'package:flutter/material.dart';
import 'package:todo_apps/ui/todo/todo.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings router) {
    switch (router.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TodoPages());
    }
    return null;
  }
}
