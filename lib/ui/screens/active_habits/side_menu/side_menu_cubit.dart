import 'package:flutter_bloc/flutter_bloc.dart';
import 'side_menu_state.dart';

class SideMenuCubit extends Cubit<SideMenuState> {
  SideMenuCubit() : super(SideMenuState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }
}
