import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/task/task_bloc.dart';
import 'package:jenga_planner/blocs/task/task_event.dart';
import 'package:jenga_planner/data/app_database.dart';
import 'package:jenga_planner/data/services/task_service.dart';
import 'package:jenga_planner/widgets/custom_text_button_widget.dart';

class FormAlertDialog extends StatefulWidget {
  final TaskData? task;

  FormAlertDialog({super.key, this.task});

  @override
  State<StatefulWidget> createState() => _FormAlertDialogState();
}

class _FormAlertDialogState extends State<FormAlertDialog> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  List<CheckListData> _subtasksData = [];

  TextEditingController? _titleController = TextEditingController();
  TextEditingController? _descriptionController = TextEditingController();
  List<TextEditingController> _subTaskControllers = [];

  _updateTask(int id) async {
    if (_formKey.currentState!.validate()) {
      final newSubtaskList =
          _subTaskControllers.map((controller) => controller.text).toList();
      await _taskService.updateTask(
        id,
        _titleController!.text,
        _descriptionController!.text,
        newSubtaskList,
      );
      return true;
    }
    return false;
  }

  Future<bool> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _taskService.saveTaskWithSubtasks(
        _titleController!.text,
        _descriptionController!.text,
        _subTaskControllers.map((controller) => controller.text).toList(),
      );
      return true;
    }
    return false;
  }

  void _removeSubTask(int index) async {
    setState(() {
      _subTaskControllers[index].dispose();
      _subTaskControllers.removeAt(index);
    });

    if (index <= _subtasksData.length - 1) {
      await _taskService.deleteSubtaskById(_subtasksData[index].id);
    }
  }

  void _addSubTask() {
    setState(() {
      _subTaskControllers = _subTaskControllers..add(TextEditingController());
    });
  }

  void _getAllSubtasksByTaskId(int taskId) async {
    final subtasks = await _taskService.getSubtasksByTaskId(taskId);
    setState(() {
      _subtasksData = subtasks;

      for (var element in _subtasksData) {
        _subTaskControllers.add(TextEditingController(text: element.title));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController = TextEditingController(
        text: widget.task!.description,
      );
      _getAllSubtasksByTaskId(widget.task!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator:
                    (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 10),
              // Task Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Description is required' : null,
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
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
              onPressed: () async {
                if (widget.task != null) {
                  await _taskService.deleteTask(widget.task!.id);
                  taskBloc.add(TaskEvent(TaskEventType.notifyTaskListChanged));
                } else {
                  Navigator.pop(context);
                }
              },
              text: widget.task != null ? 'Delete' : 'Dismiss',
              textColor: theme.colorScheme.error,
            ),
            CustomTextButton(
              onPressed: () async {
                bool isSaved = false;
                if (widget.task == null) {
                  isSaved = await _submitForm();
                } else {
                  isSaved = await _updateTask(widget.task!.id);
                }

                if (isSaved && mounted) {
                  taskBloc.add(
                    TaskEvent(TaskEventType.notifyTaskListChanged),
                  );
                }
              },
              text: widget.task == null ? 'Save Task' : 'Update Task',
            ),
          ],
        ),
      ],
    );
  }
}
