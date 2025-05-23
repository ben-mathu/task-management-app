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

    for (var i = 0; i < subtasks.length; i++) {
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

  Future<void> updateTask(int id, String title, String description, List<String> subtasks) async {
    await (_database
        .update(_database.task)..where((task) => task.id.equals(id))).write(TaskCompanion(title: Value(title), description: Value(description)));

    final dbSubtasks = await getSubtasksByTaskId(id);
    var startingIndex = 0;
    if (dbSubtasks.isNotEmpty) {
      for (final (index, subtask) in dbSubtasks.indexed) {
        await updateSubtask(subtask.id, subtasks[index]);
        startingIndex = index;
      }
      startingIndex++;
    }

    for (var i = startingIndex > 0 ? startingIndex + 1 : startingIndex; i < subtasks.length; i++) {
      final checkList = CheckListCompanion(title: Value(subtasks[i]), taskId: Value(id));
      await saveSubTask(checkList);
    }
  }

  Future<List<CheckListData>> getSubtasksByTaskId(int taskId) {
    return (_database.select(_database.checkList)..where((checklist) => checklist.taskId.equals(taskId))).get();
  }

  Future<int> deleteSubtaskById(int subtaskId) async {
    return (_database.delete(_database.checkList)..where((checklist) => checklist.id.equals(subtaskId))).go();
  }
  
  Future<void> updateSubtask(int checklistId, String title) {
    return (_database.update(_database.checkList)..where((checklist) => checklist.id.equals(checklistId))).write(CheckListCompanion(title: Value(title)));
  }

  Future<int> deleteTask(int id) async {
    return (_database.delete(_database.task)..where((task) => task.id.equals(id))).go();
  }
}
