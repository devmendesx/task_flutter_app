import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onDone,
  });

  final Task task;
  final Function(Task) onDelete;
  final Function(Task) onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              autoClose: true,
              backgroundColor: Colors.greenAccent[700]!,
              icon: Icons.done,
              onPressed: (context) {
                onDone(task);
              },
            )
          ],
        ),
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getDate(task.date)} - ${getTime(task.date)}",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                task.description,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
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
