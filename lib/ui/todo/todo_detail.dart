import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/provider/todo/todo_provider.dart';
import 'package:todo_apps/ui/widgets/forms/datepicker.dart';
import 'package:todo_apps/ui/widgets/forms/textfield.dart';

class TodoDetailPage extends StatefulWidget {
  final bool isUpdate;
  final Todo todo;

  const TodoDetailPage({super.key, required this.isUpdate, required this.todo});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add To Do")),
      body: ChangeNotifierProvider.value(
        value: TodoProvider(),
        child: Consumer<TodoProvider>(
          builder: ((context, state, child) {
            return Form(
              key: state.formKey,
              child: SingleChildScrollView(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          TxtField(
                              label: "Title",
                              value:
                                  widget.isUpdate ? widget.todo.taskName : '',
                              onChanged: (value) {
                                state.setTitle(value);
                                widget.todo.taskName = value;
                              },
                              validator: (val) =>
                                  val!.isEmpty ? 'Title must be filled' : null,
                              iconField: Icons.task),
                          TxtDatePicker(
                              label: "Start Date",
                              value: widget.isUpdate
                                  ? state.todoStartDate =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.todo.startDate!))
                                  : DateTime.now(),
                              onChanged: (value) {
                                if (value != null) {
                                  state.setStartDate(value);
                                  widget.todo.taskName = state.todoTitle;
                                }
                              }),
                          TxtDatePicker(
                              label: "Due Date",
                              value: widget.isUpdate
                                  ? state.todoDueDate =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.todo.dueDate!))
                                  : DateTime.now(),
                              onChanged: (value) {
                                if (value != null) {
                                  state.setDueDate(value);
                                }
                              }),
                          widget.isUpdate
                              ? Row(
                                  children: [
                                    Checkbox(
                                      value: widget.todo.isDone,
                                      onChanged: (value) {
                                        state.setDone(value!);
                                        widget.todo.isDone = state.isCheckDone;
                                      },
                                    ),
                                    const Text("Done")
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () async {
                                if (state.validateInput()) {
                                  if (widget.isUpdate) {
                                    Todo insertTodo = Todo();
                                    insertTodo.taskName =
                                        state.todoTitle.isEmpty
                                            ? widget.todo.taskName
                                            : state.todoTitle;
                                    insertTodo.startDate = state
                                        .todoStartDate?.millisecondsSinceEpoch
                                        .toString();
                                    insertTodo.dueDate = state
                                        .todoDueDate?.millisecondsSinceEpoch
                                        .toString();
                                    insertTodo.id = widget.todo.id;
                                    if (state.isCheckDone == null) {
                                      insertTodo.isDone = widget.todo.isDone;
                                    } else {
                                      insertTodo.isDone = state.isCheckDone;
                                    }
                                    insertTodo.starred = false;
                                    await state.updateTodo(insertTodo);

                                    // ignore: use_build_context_synchronously
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/', (route) => false);
                                  } else {
                                    Todo insertTodo = Todo();
                                    insertTodo.taskName = state.todoTitle;
                                    if (state.todoStartDate == null) {
                                      insertTodo.startDate = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                    } else {
                                      insertTodo.startDate = state
                                          .todoStartDate?.millisecondsSinceEpoch
                                          .toString();
                                    }

                                    if (state.todoDueDate == null) {
                                      insertTodo.dueDate = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                    } else {
                                      insertTodo.dueDate = state
                                          .todoDueDate?.millisecondsSinceEpoch
                                          .toString();
                                    }
                                    var result =
                                        await state.addTodo(insertTodo);
                                    if (result == 'OK') {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/', (route) => false);
                                    }
                                  }
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              )),
            );
          }),
        ),
      ),
    );
  }
}
