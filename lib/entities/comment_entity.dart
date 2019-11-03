import 'package:json_annotation/json_annotation.dart';
part 'comment_entity.g.dart';

@JsonSerializable()
class CommentEntity {
  final String text;

  CommentEntity(this.text);

  get(){
    return {'text': this.text};
  }

  factory CommentEntity.fromJson(Map<String, dynamic> json) => _$CommentEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CommentEntityToJson(this);
}


@JsonSerializable()
class CommentResultEntity {
  final String emotion;

  CommentResultEntity(this.emotion);

  get(){
    return {'emotion': this.emotion};
  }

  factory CommentResultEntity.fromJson(Map<String, dynamic> json) => _$CommentResultEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CommentResultEntityToJson(this);
}
