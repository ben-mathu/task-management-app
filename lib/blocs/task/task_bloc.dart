import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/task/task_event.dart';
import 'package:jenga_planner/blocs/task/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState(TaskStateType.initial));
}
