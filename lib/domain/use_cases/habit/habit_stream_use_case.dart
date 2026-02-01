import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/stream_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class HabitStreamUseCase
    extends StreamUseCase<DomainResponse<HabitEntity>, String> {
  HabitStreamUseCase({
    required this.habitRepo,
  });

  final HabitRepo habitRepo;

  @override
  Stream<DomainResponse<HabitEntity>> stream(
    String params,
  ) {
    return habitRepo.habitStream(habitId: params);
  }
}
