import 'package:drift/drift.dart';
import 'package:jenga_planner/data/app_database.dart';

class TaskService {
  final _database = AppDatabase.getDatabase();

  saveTaskWithSubtasks(
    String title,
    String description,
    List<String> subTasks,
  ) async {
    final task = TaskCompanion(
      title: Value(title),
      description: Value(description),
    );
    final taskId = await saveTask(task);

    List<CheckListCompanion> checkList = [];
    for (var subtask in subTasks) {
      checkList.add(CheckListCompanion(title: Value(subtask)));
    }
    for (var item in checkList) {
      item = item.copyWith(taskId: Value(taskId));
      await saveSubTask(item);
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
}
