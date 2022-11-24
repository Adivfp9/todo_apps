import 'package:flutter/material.dart';
import 'package:todo_apps/ui/todo/todo.dart';
import 'package:todo_apps/ui/todo/todo_detail.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings router) {
    switch (router.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TodoPages());
      case '/todo_detail':
        final args = router.arguments as TodoDetailPage;
        return MaterialPageRoute(builder: (context) {
          return TodoDetailPage(
            isUpdate: args.isUpdate,
            todo: args.todo,
          );
        });
    }
    return null;
  }
}
