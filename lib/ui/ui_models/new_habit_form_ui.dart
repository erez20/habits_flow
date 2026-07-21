import 'package:equatable/equatable.dart';

class NewHabitFormUI extends Equatable {
  final String title;
  final String info;
  final String link;
  final int points;

  const NewHabitFormUI({
    required this.title,
    required this.info,
    required this.link,
    required this.points,
  });

  NewHabitFormUI copyWith({
    String? title,
    String? info,
    String? link,
    int? points,
  }) {
    return NewHabitFormUI(
      title: title ?? this.title,
      info: info ?? this.info,
      link: link ?? this.link,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [title, info, link, points];
}
