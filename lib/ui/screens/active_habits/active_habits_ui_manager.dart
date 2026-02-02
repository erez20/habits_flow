import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class ActiveHabitsUIManager {
  Stream<void> listenToDrownHabit(String id);

  void addDrownHabit(String id);

  void dispose();

}

class ActiveHabitsUIManagerImpl implements ActiveHabitsUIManager {
  final BehaviorSubject<String> _drawOverHabit = BehaviorSubject<String>();

  @override
  Stream<void> listenToDrownHabit(String id) =>
      _drawOverHabit.stream.where((element) => element == id).map((_) {});

  @override
  void addDrownHabit(String id) => _drawOverHabit.add(id);

  @override
  void dispose() {
    _drawOverHabit.close();
  }
}
