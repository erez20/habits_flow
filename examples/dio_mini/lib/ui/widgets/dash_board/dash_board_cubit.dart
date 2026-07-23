import 'package:dio_mini/logic/entities/result/domain_error.dart';
import 'package:dio_mini/logic/entities/result/domain_response.dart';
import 'package:dio_mini/logic/entities/user_entity.dart' show UserEntity;
import 'package:dio_mini/logic/use_cases/user/get_user_use_case.dart';
import 'package:dio_mini/ui/common/loading_state.dart';
import 'package:dio_mini/ui/widgets/dash_board/dash_board_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  final GetUserUseCase useCase;

  DashBoardCubit({required this.useCase}) : super(DashBoardState.init());

  void pressMe({required int id}) async {
    _userFetchLoading();
    final response = await useCase.exec(id);
    switch (response) {
      case Success(:final data):
        _userFetched(data);
        break;
      case Failure(:final error, :final data):
        _userFetchError(error, data);
        break;
      case Loading():
        _userFetchLoading();
        break;
    }
  }

  void _userFetched(UserEntity data) {
    emit(
      DashBoardState(
        userEntity: data,
        loadingState: LoadingState.success,
      ),
    );
  }

  void _userFetchError(DomainError error, UserEntity? data) {
    emit(
      DashBoardState(
        userEntity: UserEntity.empty(),
        loadingState: LoadingState.error,
      ),
    );
  }

  void _userFetchLoading() {
    emit(
      DashBoardState(
        userEntity: UserEntity.empty(),
        loadingState: LoadingState.loading,
      ),
    );
  }
}
