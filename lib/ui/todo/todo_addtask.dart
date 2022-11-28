import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/data/models/todo.dart';
import 'package:todo_apps/data/provider/todo/todo_provider.dart';
import 'package:todo_apps/ui/widgets/forms/taskwidget.dart';
import 'package:todo_apps/ui/widgets/forms/textfield.dart';

class AddTaskPages extends StatefulWidget {
  final Todo todo;

  const AddTaskPages({super.key, required this.todo});

  @override
  State<AddTaskPages> createState() => _AddTaskPagesState();
}

class _AddTaskPagesState extends State<AddTaskPages> {
  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd-MMM-yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text("Add Sub Task")),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Task Detail",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    CustomDetailTask(
                                      caption: 'Task Name',
                                      capvalue: widget.todo.taskName!,
                                    ),
                                    CustomDetailTask(
                                      caption: 'Start Date',
                                      capvalue: f.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                  widget.todo.startDate!))),
                                    ),
                                    CustomDetailTask(
                                      caption: 'Due Date',
                                      capvalue: f.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(widget.todo.dueDate!))),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Add Sub Task",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TxtField(
                                      label: "Sub Task Name",
                                      onChanged: (value) {
                                        state.setTitle(value);
                                      },
                                      iconField: Icons.task),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        if (state.validateInput()) {
                                          Todo insertTodo = Todo();
                                          insertTodo.parentId = widget.todo.id;
                                          insertTodo.taskName = state.todoTitle;
                                          insertTodo.startDate =
                                              widget.todo.startDate;
                                          insertTodo.dueDate =
                                              widget.todo.dueDate;

                                          var result =
                                              await state.addTodo(insertTodo);
                                          if (result == 'OK') {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, '/', (route) => false);
                                          }
                                        }
                                      },
                                      child: const Text("Save"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
