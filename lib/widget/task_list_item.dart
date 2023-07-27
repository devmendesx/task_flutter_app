import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screen/task_list_page.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task, required this.onDelete});

  final Task task;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              autoClose: true,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (context) {
                onDelete(task);
              },
            )
          ],
        ),
        child: Container(
          color: Colors.grey[200],
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getDate(task.date)} - ${getTime(task.date)}",
                style: const TextStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTime(DateTime datetime) {
    String hour = DateFormat.Hm().format(datetime);
    return hour;
  }

  String getDate(DateTime dateTime) {
    String hour = DateFormat('dd/MM/yyyy').format(dateTime);
    return hour;
  }
}
