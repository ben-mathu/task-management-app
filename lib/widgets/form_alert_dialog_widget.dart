import 'package:flutter/material.dart';
import 'package:jenga_planner/data/app_database.dart';
import 'package:jenga_planner/data/services/task_service.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';
import 'package:jenga_planner/widgets/custom_text_button_widget.dart';
import 'package:jenga_planner/widgets/task_form.dart';

class FormAlertDialog extends StatefulWidget {
  final TaskData? task;

  FormAlertDialog({super.key, this.task});

  @override
  State<StatefulWidget> createState() => _FormAlertDialogState();
}

class _FormAlertDialogState extends State<FormAlertDialog> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  List<String> _subTasks = List.empty();

  _updateTask(int id) async {
    _taskService.updateTask(id, _title!, _description!);
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _taskService.saveTaskWithSubtasks(
        _title!,
        _description!,
        _subTasks,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: TaskForm(
        _formKey,
        widget.task,
        (value) {
          setState(() {
            _title = value;
          });
        },
        (value) {
          setState(() {
            _description = value;
          });
        },
        (List<String> subtasks) {
          _subTasks = subtasks;
        },
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(onPressed: () {
              Navigator.pop(context);
            }, text: 'Dismiss'),
            CustomTextButton(onPressed: () {
              if (widget.task == null) {
                _submitForm();
              } else {
                _updateTask(widget.task!.id);
              }
            }, text: widget.task == null ? 'Save Task' : 'Update Task'),
          ],
        ),
      ],
    );
  }
}
