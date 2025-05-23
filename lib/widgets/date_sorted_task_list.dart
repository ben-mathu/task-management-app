import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jenga_planner/data/app_database.dart';
import 'package:jenga_planner/data/models.dart';

class DateSortedTaskList extends StatelessWidget {
  final TaskData task;
  final VoidCallback openDialog;
  const DateSortedTaskList({super.key, required this.task, required this.openDialog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          task.description!.length > 50
              ? '${task.description!.substring(0, 50)}...'
              : task.description!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          openDialog();
        },
      ),
    );
  }
}