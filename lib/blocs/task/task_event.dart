enum TaskEventType { notifyTaskListChanged }

class TaskEvent {
  final TaskEventType type;
  TaskEvent(this.type);
}
