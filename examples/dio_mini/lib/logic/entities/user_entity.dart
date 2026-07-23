import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String createdAt;
  final String avatar;

  const UserEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.avatar,
  });

  const UserEntity.empty()
    : this(
        id: "",
        name: "",
        createdAt: "",
        avatar: "",
      );

  bool get isEmpty => id.isEmpty;

  @override
  List<Object?> get props => [id, name, createdAt, avatar];
}
