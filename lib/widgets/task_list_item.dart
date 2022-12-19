import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    Key? key,
    required this.task,
    required this.onDelete,
  }) : super(key: key);

  final Task task;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        endActionPane:  ActionPane(
          extentRatio: 0.5,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              label: 'Deletar',
              backgroundColor: const Color.fromARGB(255, 255, 17, 0),
              icon: Icons.delete,
              onPressed: (context) {
                onDelete(task);
              },
            ),
            const SlidableAction(
              label: 'Editar',
              backgroundColor: Color.fromARGB(255, 55, 52, 255),
              icon: Icons.edit,
              onPressed: null,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(DateFormat('dd/MM/yyyy - HH:mm').format(task.dateTime),
                  style: const TextStyle(fontSize: 12)),
              Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
