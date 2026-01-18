import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/habits/habit_local_source.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: HabitLocalSource)
class HabitLocalSourceImpl implements HabitLocalSource {
  final AppDatabase db;

  HabitLocalSourceImpl(this.db);

  @override
  Future<HabitEntity> createHabit({
    required String title,
    required int weight,
  }) async {
    final id = const Uuid().v4();
    final companion = HabitsCompanion.insert(
      id: id,
      title: title,
      weight: Value(weight),
      createdAt: Value(DateTime.now()),
    );

    await db.into(db.habits).insert(companion);

    return HabitEntity(
      id: id,
      title: title,
      weight: weight,
      info: '',
      completionCount: 0,
    );
  }

  @override
  Future<void> deleteHabit({required String habitId}) async {
    await (db.delete(db.habits)..where((tbl) => tbl.id.equals(habitId))).go();
  }
}
