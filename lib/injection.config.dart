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
import 'package:habits_flow/data/repos/group_repo_impl.dart' as _i38;
import 'package:habits_flow/data/repos/habit_repo_impl.dart' as _i375;
import 'package:habits_flow/data/sources/groups/group_local_source.dart'
    as _i25;
import 'package:habits_flow/data/sources/groups/group_local_source_impl.dart'
    as _i646;
import 'package:habits_flow/data/sources/habits/habit_local_source.dart'
    as _i545;
import 'package:habits_flow/data/sources/habits/habit_local_source_impl.dart'
    as _i995;
import 'package:habits_flow/domain/repos/group_repo.dart' as _i136;
import 'package:habits_flow/domain/repos/habit_repo.dart' as _i877;
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart'
    as _i655;
import 'package:habits_flow/domain/use_cases/group/delete_group_use_case.dart'
    as _i227;
import 'package:habits_flow/domain/use_cases/group/get_group_ids_list_use_case.dart'
    as _i600;
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart'
    as _i262;
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_cubit.dart'
    as _i312;
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
    gh.factory<_i25.GroupLocalSource>(
      () => _i646.GroupLocalSourceImpl(gh<_i118.AppDatabase>()),
    );
    gh.lazySingleton<_i136.GroupRepo>(
      () => _i38.GroupRepoImpl(groupLocalSource: gh<_i25.GroupLocalSource>()),
    );
    gh.factory<_i262.AddHabitUseCase>(
      () => _i262.AddHabitUseCase(
        habitRepo: gh<_i877.HabitRepo>(),
        groupRepo: gh<_i136.GroupRepo>(),
      ),
    );
    gh.factory<_i655.AddGroupUseCase>(
      () => _i655.AddGroupUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i227.DeleteGroupUseCase>(
      () => _i227.DeleteGroupUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i600.GetGroupIdsListUseCase>(
      () => _i600.GetGroupIdsListUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    gh.factory<_i312.TestDashboardCubit>(
      () => _i312.TestDashboardCubit(
        addHabitUseCase: gh<_i262.AddHabitUseCase>(),
        addGroupUseCase: gh<_i655.AddGroupUseCase>(),
        getGroupIdsListUseCase: gh<_i600.GetGroupIdsListUseCase>(),
      ),
    );
    return this;
  }
}
