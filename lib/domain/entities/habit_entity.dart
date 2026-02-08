import 'package:equatable/equatable.dart';
class HabitEntity extends Equatable{
  final String id;
  final String title;
  final String info;
  final String link;
  final double weight;
  final int completionCount;
  final int groupColor;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.info,
    required this.link,
    required this.weight,
    required this.completionCount,
    required this.groupColor,
  });

  String get hashKey => Object.hash(id, title, weight, completionCount, info, link, groupColor).toString();

  @override
  List<Object?> get props => [id, title, weight, completionCount, info, link, groupColor];

  bool get isUncompleted => completionCount == 0;

  bool get isCompleted => completionCount > 0;
}
