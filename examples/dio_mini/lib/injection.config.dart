// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:dio_mini/data/injectable/register_data_module.dart' as _i272;
import 'package:dio_mini/data/network/client/network_client.dart' as _i15;
import 'package:dio_mini/data/repos/user_repo_impl.dart' as _i524;
import 'package:dio_mini/data/user/remote_source/user_remote_source.dart'
    as _i765;
import 'package:dio_mini/logic/repos/user_repo.dart' as _i710;
import 'package:dio_mini/logic/use_cases/user/get_user_use_case.dart' as _i670;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerDataModule = _$RegisterDataModule();
    gh.lazySingleton<_i15.NetworkClient>(() => _i15.NetworkClient());
    gh.factory<_i361.Dio>(
      () => registerDataModule.getDio(gh<_i15.NetworkClient>()),
    );
    gh.factory<_i765.UserRemoteSource>(
      () => _i765.UserRemoteSource(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i710.UserRepo>(
      () => _i524.UserRepoImpl(userRemoteSource: gh<_i765.UserRemoteSource>()),
    );
    gh.factory<_i670.GetUserUseCase>(
      () => _i670.GetUserUseCase(userRepo: gh<_i710.UserRepo>()),
    );
    return this;
  }
}

class _$RegisterDataModule extends _i272.RegisterDataModule {}
