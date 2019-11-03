// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentEntity _$CommentEntityFromJson(Map<String, dynamic> json) {
  return CommentEntity(json['text'] as String);
}

Map<String, dynamic> _$CommentEntityToJson(CommentEntity instance) =>
    <String, dynamic>{'text': instance.text};

CommentResultEntity _$CommentResultEntityFromJson(Map<String, dynamic> json) {
  return CommentResultEntity(json['emotion'] as String);
}

Map<String, dynamic> _$CommentResultEntityToJson(
        CommentResultEntity instance) =>
    <String, dynamic>{'emotion': instance.emotion};
