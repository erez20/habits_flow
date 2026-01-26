import 'package:flutter_bloc/flutter_bloc.dart';

import 'habits_collection_state.dart';

class HabitsCollectionCubit extends Cubit<HabitCollectionState> {
  final String groupId;

  HabitsCollectionCubit({required this.groupId}) : super(HabitCollectionState(habits: [])) {init();}

  void init() {}

}