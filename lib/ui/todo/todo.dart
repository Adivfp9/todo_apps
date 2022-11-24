import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/provider/todo/todo_provider.dart';
import 'package:todo_apps/ui/todo/todo_detail.dart';

class TodoPages extends StatelessWidget {
  const TodoPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To Do List"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/todo_detail',
                arguments: TodoDetailPage(isUpdate: false, todo: Todo()));
          },
          child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
        body: ChangeNotifierProvider.value(
          value: TodoProvider(),
          child: Consumer<TodoProvider>(
            builder: (context, state, child) {
              return Form(
                key: state.formKey,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await state.getTodoList();
                  },
                  child: ListView.builder(
                    itemCount: state.todoList.length,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, idx) {
                      var todo = state.todoList[idx];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/todo_detail',
                              arguments: TodoDetailPage(
                                isUpdate: true,
                                todo: state.todoList[idx],
                              ));
                        },
                        child: Card(
                          elevation: 5.0,
                          color: todo.isDone! ? Colors.green : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: Text(
                                '${todo.taskName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Checkbox(
                                value: todo.isDone,
                                onChanged: (value) async {
                                  state.setDone(value!);
                                  todo.isDone = state.isCheckDone;
                                  Todo updateTodo = Todo();
                                  updateTodo.taskName = todo.taskName;
                                  updateTodo.startDate = todo.startDate;
                                  updateTodo.dueDate = todo.dueDate;
                                  updateTodo.id = todo.id;
                                  updateTodo.starred = false;
                                  updateTodo.isDone = state.isCheckDone;
                                  print(updateTodo.toJson());
                                  print(state.isCheckDone);

                                  await state.updateTodo(updateTodo);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ));
  }
}
