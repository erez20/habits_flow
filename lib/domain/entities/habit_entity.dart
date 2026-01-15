import 'package:equatable/equatable.dart';
class HabitEntity extends Equatable{
  final String id;
  final String title;
  final int weight;
  final int completionCount;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.weight,
    required this.completionCount,
  });

  @override
  List<Object?> get props => [id, title, weight, completionCount];
}
