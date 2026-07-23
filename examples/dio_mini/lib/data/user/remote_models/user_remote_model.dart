
import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_remote_model.g.dart';

@JsonSerializable()
class UserRemoteModel {
  String id;
  String name;
  String createdAt;
  String avatar;

  UserRemoteModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.avatar,
  });

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        createdAt: createdAt,
        avatar: avatar,
      );


  factory UserRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$UserRemoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRemoteModelToJson(this);

  UserRemoteModel copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? avatar,
  }) {
    return UserRemoteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatar: avatar ?? this.avatar,
    );
  }
}