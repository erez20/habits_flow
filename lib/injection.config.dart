// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:habits_flow/data/db/database.dart' as _i118;
import 'package:habits_flow/data/repos/backup_repo_impl.dart' as _i769;
import 'package:habits_flow/data/repos/group_repo_impl.dart' as _i38;
import 'package:habits_flow/data/repos/habit_repo_impl.dart' as _i375;
import 'package:habits_flow/data/repos/refresh_scheduler_repo_impl.dart'
    as _i186;
import 'package:habits_flow/data/sources/backup/backup_local_source.dart'
    as _i877;
import 'package:habits_flow/data/sources/backup/backup_local_source_impl.dart'
    as _i705;
import 'package:habits_flow/data/sources/groups/group_local_source.dart'
    as _i25;
import 'package:habits_flow/data/sources/groups/group_local_source_impl.dart'
    as _i646;
import 'package:habits_flow/data/sources/habits/habit_local_source.dart'
    as _i545;
import 'package:habits_flow/data/sources/habits/habit_local_source_impl.dart'
    as _i995;
import 'package:habits_flow/domain/repos/backup_repo.dart' as _i600;
import 'package:habits_flow/domain/repos/group_repo.dart' as _i136;
import 'package:habits_flow/domain/repos/habit_repo.dart' as _i877;
import 'package:habits_flow/domain/repos/refresh_scheduler_repo.dart' as _i184;
import 'package:habits_flow/domain/use_cases/group/add_dummy_habit_to_first_group_use_case.dart'
    as _i349;
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart'
    as _i655;
import 'package:habits_flow/domain/use_cases/group/delete_group_use_case.dart'
    as _i227;
import 'package:habits_flow/domain/use_cases/group/generate_dummy_group_name_use_case.dart'
    as _i715;
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart'
    as _i779;
import 'package:habits_flow/domain/use_cases/group/remove_last_dummy_group_use_case.dart'
    as _i587;
import 'package:habits_flow/domain/use_cases/group/reorder_groups_use_case.dart'
    as _i368;
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart'
    as _i262;
import 'package:habits_flow/domain/use_cases/habit/delete_habit_use_case.dart'
    as _i318;
import 'package:habits_flow/domain/use_cases/habit/habit_stream_use_case.dart'
    as _i271;
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart'
    as _i1073;
import 'package:habits_flow/domain/use_cases/habit/perform_habit_use_case.dart'
    as _i82;
import 'package:habits_flow/domain/use_cases/habit/reorder_habit_use_case.dart'
    as _i618;
import 'package:habits_flow/domain/use_cases/habit/reset_habit_use_case.dart'
    as _i1072;
import 'package:habits_flow/domain/use_cases/shared/generate_backup_use_case.dart'
    as _i182;
import 'package:habits_flow/domain/use_cases/shared/refresh_all_use_case.dart'
    as _i315;
import 'package:habits_flow/domain/use_cases/shared/restore_backup_use_case.dart'
    as _i112;
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart'
    as _i28;
import 'package:habits_flow/ui/widgets/all_groups/all_groups_cubit.dart'
    as _i967;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i118.AppDatabase>(() => _i118.AppDatabase());
    gh.factory<_i545.HabitLocalSource>(
      () => _i995.HabitLocalSourceImpl(gh<_i118.AppDatabase>()),
    );
    gh.lazySingleton<_i877.HabitRepo>(
      () =>
          _i375.HabitRepoImpl(habitsLocalSource: gh<_i545.HabitLocalSource>()),
    );
    gh.factory<_i28.ActiveHabitsManager>(() => _i28.ActiveHabitsManagerImpl());
    gh.factory<_i318.DeleteHabitUseCase>(
      () => _i318.DeleteHabitUseCase(habitRepo: gh<_i877.HabitRepo>()),
    );
    gh.factory<_i271.HabitStreamUseCase>(
      () => _i271.HabitStreamUseCase(habitRepo: gh<_i877.HabitRepo>()),
    );
    gh.factory<_i82.PerformHabitUseCase>(
      () => _i82.PerformHabitUseCase(habitRepo: gh<_i877.HabitRepo>()),
    );
    gh.factory<_i1072.ResetHabitUseCase>(
      () => _i1072.ResetHabitUseCase(habitRepo: gh<_i877.HabitRepo>()),
    );
    gh.factory<_i25.GroupLocalSource>(
      () => _i646.GroupLocalSourceImpl(gh<_i118.AppDatabase>()),
    );
    gh.factory<_i877.BackupLocalSource>(
      () => _i705.BackupLocalSourceImpl(gh<_i118.AppDatabase>()),
    );
    gh.lazySingleton<_i136.GroupRepo>(
      () => _i38.GroupRepoImpl(groupLocalSource: gh<_i25.GroupLocalSource>()),
    );
    gh.factory<_i1073.HabitsOfGroupStreamUseCase>(
      () => _i1073.HabitsOfGroupStreamUseCase(gh<_i877.HabitRepo>()),
    );
    gh.lazySingleton<_i600.BackupRepo>(
      () => _i769.BackupRepoImpl(
        backupLocalSource: gh<_i877.BackupLocalSource>(),
      ),
    );
    gh.factory<_i262.AddHabitUseCase>(
      () => _i262.AddHabitUseCase(
        habitRepo: gh<_i877.HabitRepo>(),
        groupRepo: gh<_i136.GroupRepo>(),
      ),
    );
    gh.factory<_i349.AddDummyHabitToFirstGroupUseCase>(
      () => _i349.AddDummyHabitToFirstGroupUseCase(repo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i587.RemoveLastDummyGroupUseCase>(
      () => _i587.RemoveLastDummyGroupUseCase(repo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i618.ReorderHabitUseCase>(
      () => _i618.ReorderHabitUseCase(repo: gh<_i877.HabitRepo>()),
    );
    gh.lazySingleton<_i184.RefreshSchedulerRepo>(
      () => _i186.RefreshSchedulerRepoImpl(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i368.ReorderGroupsUseCase>(
      () => _i368.ReorderGroupsUseCase(gh<_i136.GroupRepo>()),
    );
    gh.factory<_i655.AddGroupUseCase>(
      () => _i655.AddGroupUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i227.DeleteGroupUseCase>(
      () => _i227.DeleteGroupUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i715.GenerateDummyGroupNameUseCase>(
      () =>
          _i715.GenerateDummyGroupNameUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i779.GroupsListStreamUseCase>(
      () => _i779.GroupsListStreamUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i182.GenerateBackupUseCase>(
      () => _i182.GenerateBackupUseCase(backupRepo: gh<_i600.BackupRepo>()),
    );
    gh.factory<_i112.RestoreBackupUseCase>(
      () => _i112.RestoreBackupUseCase(backupRepo: gh<_i600.BackupRepo>()),
    );
    gh.factory<_i315.RefreshAllUseCase>(
      () => _i315.RefreshAllUseCase(
        groupRepo: gh<_i136.GroupRepo>(),
        habitRepo: gh<_i877.HabitRepo>(),
        refreshSchedulerRepo: gh<_i184.RefreshSchedulerRepo>(),
      ),
    );
    gh.factory<_i967.AllGroupsCubit>(
      () => _i967.AllGroupsCubit(
        groupsListStreamUseCase: gh<_i779.GroupsListStreamUseCase>(),
        reorderGroupsUseCase: gh<_i368.ReorderGroupsUseCase>(),
        manager: gh<_i28.ActiveHabitsManager>(),
      ),
    );
    return this;
  }
}
