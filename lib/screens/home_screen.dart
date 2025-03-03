import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/task/task_bloc.dart';
import 'package:jenga_planner/blocs/task/task_state.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';
import 'package:jenga_planner/widgets/task_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskCount = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (BuildContext context, TaskState state) {},
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
                _taskCount <= 0
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
                    : Text('Your first task'),
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

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text('Add Task'), content: TaskForm());
      },
    );
  }
}
