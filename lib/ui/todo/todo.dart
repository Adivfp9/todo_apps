import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/provider/todo/todo_provider.dart';
import 'package:todo_apps/ui/todo/todo_detail.dart';
import 'package:todo_apps/ui/widgets/forms/textfield.dart';

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
                      final f = DateFormat('dd-MMM-yyyy');

                      DateTime starDateVal = todo.startDate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              int.parse(todo.startDate!))
                          : DateTime.now();
                      DateTime dueDateVal = todo.dueDate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              int.parse(todo.dueDate!))
                          : DateTime.now();

                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          elevation: 2.0,
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.all(5),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    shoConfirmDialog(state, todo, context);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20.0,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/todo_detail',
                                        arguments: TodoDetailPage(
                                          isUpdate: true,
                                          todo: state.todoList[idx],
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20.0,
                                    color: Colors.blue,
                                  ),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              ],
                            ),
                            childrenPadding: const EdgeInsets.all(5),
                            children: state.subTodoList
                                .where((element) => todo.id == element.parentId)
                                .map((val) => ListTile(
                                      leading: IconButton(
                                        onPressed: () {
                                          shoConfirmDialog(state, val, context);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                      title: Text(
                                        val.taskName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: Colors.black87),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          showCustomDialog(state, val, context);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20.0,
                                        ),
                                      ),
                                    ))
                                .toList(),
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

  void shoConfirmDialog(
      TodoProvider state, Todo todostate, BuildContext context) async {
    var status = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete this task ?'),
            content: Text(todostate.taskName!),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  await state.deleteData(todostate.id!);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop('success');
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
    if (status == "success") {
      state.getTodoList();
    }
  }

  void showCustomDialog(
      TodoProvider state, Todo todostate, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Child Todo"),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListBody(
                  children: [
                    TxtField(
                      label: "Title",
                      onChanged: (value) {
                        state.setTitle(value);
                      },
                      iconField: Icons.text_format,
                      value: todostate.taskName,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        Todo updateTodo = Todo();
                        updateTodo.taskName = state.todoTitle;
                        updateTodo.parentId = todostate.parentId;
                        updateTodo.startDate =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        updateTodo.dueDate =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        updateTodo.id = todostate.id;
                        updateTodo.starred = false;
                        updateTodo.isDone = false;

                        await state.updateTodo(updateTodo);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        state.getTodoList();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
