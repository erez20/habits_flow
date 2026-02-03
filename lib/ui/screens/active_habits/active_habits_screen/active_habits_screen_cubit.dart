import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/ui/widgets/new_group_form/new_group_form_ui_model.dart';
import 'active_habits_screen_state.dart';

class ActiveHabitsScreenCubit extends Cubit<ActiveHabitsScreenState> {
  final AddGroupUseCase addGroupUseCase;

  ActiveHabitsScreenCubit({
    required this.addGroupUseCase,
  }) : super(ActiveHabitsScreenState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void addGroup({required NewGroupFormUIModel uiModel}) {
    Fimber.d('addGroup');
    addGroupUseCase.exec(
      AddGroupUseCaseParams(
        title: uiModel.title, weight: 4, colorValue: 4,
      ),
    );
  }
}
