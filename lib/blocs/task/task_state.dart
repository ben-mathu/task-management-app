enum TaskStateType { initial, update }

class TaskState {
  final TaskStateType type;
  TaskState(this.type);
}
