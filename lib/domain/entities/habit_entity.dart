import 'package:equatable/equatable.dart';
class HabitEntity extends Equatable{
  final String id;
  final String title;
  final String info;
  final String link;
  final double weight;
  final int completionCount;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.info,
    required this.link,
    required this.weight,
    required this.completionCount,
  });

  String get hashKey => Object.hash(id, title, weight, completionCount, info, link).toString();

  @override
  List<Object?> get props => [id, title, weight, completionCount, info, link];
}
