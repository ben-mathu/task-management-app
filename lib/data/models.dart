import 'package:drift/drift.dart';

class Task extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 25)();
  TextColumn get subtitle => text().withLength(min: 6, max: 56)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
}
