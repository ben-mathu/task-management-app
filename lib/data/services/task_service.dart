import 'package:drift/drift.dart';
import 'package:jenga_planner/data/app_database.dart';

class TaskService {
  final _database = AppDatabase.getDatabase();

  saveTaskWithSubtasks(
    String title,
    String description,
    List<String> subtasks,
  ) async {
    final task = TaskCompanion(
      title: Value(title),
      description: Value(description),
    );
    final taskId = await saveTask(task);

    final dbSubtasks = await getSubtasksByTaskId(taskId);
    var startingIndex = 0;
    if (dbSubtasks.isNotEmpty) {
      for (final (index, subtask) in dbSubtasks.indexed) {
        final checklist = subtask.toCompanion(true);
        await updateSubtask(checklist.copyWith(title: Value(subtasks[index])));
        startingIndex = index;
      }
    }

    for (var i = startingIndex > 0 ? startingIndex + 1 : startingIndex; i < subtasks.length; i++) {
      final checkList = CheckListCompanion(title: Value(subtasks[i]), taskId: Value(taskId));
      await saveSubTask(checkList);
    }
  }

  Future<int> saveTask(TaskCompanion task) async {
    return await _database
        .into(_database.task)
        .insert(task, mode: InsertMode.replace);
  }

  saveSubTask(CheckListCompanion item) async {
    await _database
        .into(_database.checkList)
        .insert(item, mode: InsertMode.replace);
  }

  Future<List<TaskData>> getTasks() {
    return _database.select(_database.task).get();
  }

  Future<void> updateTask(int id, String title, String description) async {
    await _database
        .update(_database.task).write(TaskCompanion(id: Value(id), title: Value(title), description: Value(description)))
    ;
  }

  Future<List<CheckListData>> getSubtasksByTaskId(int taskId) {
    return (_database.select(_database.checkList)..where((checklist) => checklist.taskId.equals(taskId))).get();
  }

  Future<void> deleteSubtaskById(int subtaskId) async {
    return (_database.delete(_database.checkList).where((checklist) => checklist.id.equals(subtaskId)));
  }
  
  Future<void> updateSubtask(CheckListCompanion checklist) {
    return _database.update(_database.checkList).write(checklist);
  }
}
