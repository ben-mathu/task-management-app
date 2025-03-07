import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/task/task_bloc.dart';
import 'package:jenga_planner/blocs/task/task_state.dart';
import 'package:jenga_planner/data/app_database.dart';
import 'package:jenga_planner/data/services/task_service.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';
import 'package:jenga_planner/widgets/form_alert_dialog_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<TaskData> _tasks = List.empty();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (BuildContext context, TaskState state) {
        if (state.type == TaskStateType.update) {
          Navigator.pop(context);
          _taskService.getTasks().then(
            (tasks) => {
              setState(() {
                _tasks = tasks;
              }),
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your tasks'),
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child:
                _tasks.isEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('You have an empty task lists'),
                        CustomButton(
                          onPressed: () {
                            _showDialog(context);
                          },
                          text: 'Add tasks',
                        ),
                      ],
                    )
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

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
                              _showDialog(context, task);
                            },
                          ),
                        );
                      },
                    ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, [TaskData? task]) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormAlertDialog(task: task);
      },
    );
  }
}
