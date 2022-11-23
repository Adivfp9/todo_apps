import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/data/provider/todo/todo_provider.dart';

class TodoPages extends StatelessWidget {
  const TodoPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To Do List"),
        ),
        body: ChangeNotifierProvider.value(
          value: TodoProvider(),
          child: Consumer<TodoProvider>(
            builder: (context, state, child) {
              return RefreshIndicator(
                onRefresh: () async {
                  await state.getTodoList();
                },
                child: ListView.builder(
                  itemCount: state.todoList.length,
                  itemBuilder: (context, idx) {
                    var todo = state.todoList[idx];
                    return Card(
                      child: ListTile(
                        title: Text('${todo.taskName}'),
                        trailing: Checkbox(
                          value: todo.isDone,
                          onChanged: (bool? value) {
                            state.setDone(value!);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}
