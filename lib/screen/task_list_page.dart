import 'package:flutter/material.dart';
import 'package:task_app/widget/task_list_item.dart';

import '../model/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController taskInputController = TextEditingController();
  late List<Task> tasks = List.empty(growable: true);
  late String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: const Text(
                  "Tasks",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (description) {
                        if (description.isNotEmpty) addTask();
                      },
                      onChanged: (text) => setState(() {
                        description = taskInputController.text;
                      }),
                      controller: taskInputController,
                      decoration: const InputDecoration(
                          labelText: "Add task", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: description.isEmpty ? null : addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 400,
                  child: tasks.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildItem(tasks[index]),
                        )
                      : const Text(
                          "Empty tasks.",
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("There are ${tasks.length} pending tasks. ",
                        style: const TextStyle(fontSize: 14)),
                    InkWell(
                      onTap: dialogDeleteModal,
                      child: const Text(
                        "Clean tasks.",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TaskListItem buildItem(Task task) => TaskListItem(
        task: task,
        onDelete: onDelete,
        onDone: onDone,
      );

  void dialogDeleteModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("DELETE CONFIRMATION"),
        content: const Text("Have you sure on deleting all tasks?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cleanTasks();
              },
              child: const Text(
                "DELETE",
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }

  void clearSnackBarsInRow() => ScaffoldMessenger.of(context).clearSnackBars();

  void showSnackBarDoneTask() =>
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Well done, task ok!",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ));

  void showSnackBarForDeletedTask(Task task, int index) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            const Text("Task deleted!", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            onUndo(task, index);
          },
        ),
      ));

  void onUndo(Task task, int index) {
    setState(() {
      tasks.insert(index, task);
    });
  }

  void addTask() {
    setState(() {
      tasks.add(Task(description: taskInputController.text));
      description = "";
    });
    FocusManager.instance.primaryFocus?.unfocus();
    taskInputController.clear();
  }

  void onDelete(Task task) {
    var taskIndex = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
    });
    clearSnackBarsInRow();
    showSnackBarForDeletedTask(task, taskIndex);
  }

  void onDone(Task task) {
    setState(() {
      tasks.remove(task);
    });
    showSnackBarDoneTask();
  }

  void cleanTasks() {
    setState(() {
      tasks.clear();
    });
  }
}
