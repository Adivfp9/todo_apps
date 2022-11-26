import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                      final f = DateFormat('dd-MMMM-yyyy');

                      DateTime starDateVal = todo.startDate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              int.parse(todo.startDate!))
                          : DateTime.now();
                      DateTime dueDateVal = todo.dueDate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              int.parse(todo.dueDate!))
                          : DateTime.now();

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/todo_detail',
                              arguments: TodoDetailPage(
                                isUpdate: true,
                                todo: state.todoList[idx],
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                          child: Card(
                            elevation: 5.0,
                            color: todo.isDone! ? Colors.green : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        todo.taskName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.0,
                                            color: Colors.black87),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Start Date : ${f.format(starDateVal)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                            color: todo.isDone!
                                                ? Colors.black
                                                : Colors.blueGrey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Due Date : ${f.format(dueDateVal)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                            color: todo.isDone!
                                                ? Colors.black
                                                : Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  Checkbox(
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

                                      await state.updateTodo(updateTodo);
                                    },
                                  ),
                                ],
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
