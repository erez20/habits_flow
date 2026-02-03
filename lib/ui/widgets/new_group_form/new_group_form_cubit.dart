import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_state.dart';

class NewGroupFormCubit extends Cubit<NewGroupFormState> {
  NewGroupFormCubit() : super(NewGroupFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }
}
