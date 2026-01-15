// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:habits_flow/data/repos/group_repo_impl.dart' as _i38;
import 'package:habits_flow/data/sources/groups/group_local_source.dart' as _i110;
import 'package:habits_flow/data/sources/groups/mock_group_local_source.dart' as _i345;
import 'package:habits_flow/domain/repos/group_repo.dart' as _i136;
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart'
    as _i655;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i110.GroupLocalSource>(() => _i345.GroupLocalSourceMock());
    gh.lazySingleton<_i136.GroupRepo>(
      () => _i38.GroupRepoImpl(groupLocalSource: gh<_i110.GroupLocalSource>()),
    );
    gh.factory<_i655.AddGroupUseCase>(
      () => _i655.AddGroupUseCase(groupRepo: gh<_i136.GroupRepo>()),
    );
    return this;
  }
}
