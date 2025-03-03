import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:jenga_planner/data/models.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Task, CheckList])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'jenga', native: const DriftNativeOptions());
  }
}
