import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_group_form_state.dart';

class EditGroupFormCubit extends Cubit<EditGroupFormState> {
  EditGroupFormCubit() : super(EditGroupFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }
}
