import 'package:habits_flow/data/sources/habits/habit_local_source.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HabitLocalSource)
class MockHabitLocalSource extends HabitLocalSource {
  static int i = 1;

  @override
  Future<HabitEntity> createHabit({
    required String title,
    required int weight,
  }) {
    return Future.value(
      HabitEntity(
        id: (i++).toString(),
        title: title,
        weight: weight,
        completionCount: 0,
        info: '',
      ),
    );
  }

  @override
  Future<void> deleteHabit({required String habitId}) {
    return Future.value();
  }
}
