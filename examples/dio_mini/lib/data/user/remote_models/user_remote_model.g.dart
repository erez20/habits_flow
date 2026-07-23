// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_remote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRemoteModel _$UserRemoteModelFromJson(Map<String, dynamic> json) =>
    UserRemoteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$UserRemoteModelToJson(UserRemoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'avatar': instance.avatar,
    };
