import 'package:drift/drift.dart';
import 'package:jenga_planner/data/app_database.dart';

class TaskService {
  final _database = AppDatabase();

  saveTask(String title, String description, List<String> subTasks) async {
    final task = TaskCompanion(
      title: Value(title),
      description: Value(description),
    );
    final taskId = await _database.into(_database.task).insert(task);

    List<CheckListCompanion> checkList = List.empty();
    for (var subtask in subTasks) {
      checkList.add(CheckListCompanion(title: Value(subtask)));
    }
    for (var item in checkList) {
      item = item.copyWith(taskId: Value(taskId));
      await _database.into(_database.checkList).insert(item);
    }
  }
}
