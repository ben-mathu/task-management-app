import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/task/task_bloc.dart';
import 'package:jenga_planner/blocs/task/task_event.dart';
import 'package:jenga_planner/data/app_database.dart';
import 'package:jenga_planner/data/services/task_service.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';

class TaskForm extends StatefulWidget {
  final GlobalKey formKey;
  final TaskData? task;
  final Function(String value) onTitleChanges;
  final Function(String value) onDescriptionChanges;
  final Function(List<String> subtasks) onSubtasksUpdated;
  TaskForm(this.formKey, this.task, this.onTitleChanges, this.onDescriptionChanges, this.onSubtasksUpdated, {super.key});

  @override
  State<StatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TaskService _taskService = TaskService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<TextEditingController> _subTaskControllers = [];

  void _addSubTask() {
    setState(() {
      _subTaskControllers.add(TextEditingController());
      widget.onSubtasksUpdated(_subTaskControllers.map((controller) => controller.text).toList());
    });
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTaskControllers[index].dispose();
      _subTaskControllers.removeAt(index);

      widget.onSubtasksUpdated(_subTaskControllers.map((controller) => controller.text).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);

    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
              validator: (value) => value!.isEmpty ? 'Title is required' : null,
              onChanged: (value) => widget.onTitleChanges(value),
            ),
            SizedBox(height: 10),

            // Task Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator:
                  (value) => value!.isEmpty ? 'Description is required' : null,
              onChanged: (value) => widget.onDescriptionChanges(value),
            ),
            SizedBox(height: 10),

            // Sub-Tasks List
            Text(
              'Sub-Tasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: List.generate(_subTaskControllers.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _subTaskControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Sub-Task ${index + 1}',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Sub-task cannot be empty'
                                    : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeSubTask(index),
                    ),
                  ],
                );
              }),
            ),

            // Add Sub-Task Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _addSubTask,
                icon: Icon(Icons.add),
                label: Text('Add Sub-Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
