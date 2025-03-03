import 'package:drift/drift.dart';

class Task extends Table {
  @override
  String get tableName => 'tasks';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

class CheckList extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().customConstraint('REFERENCES tasks(id) ON DELETE CASCADE')();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
}
