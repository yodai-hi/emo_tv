import 'dart:async';
import 'package:emo_tv/entities/comment_entity.dart';
import 'package:emo_tv/repository/comment_repository.dart';
import 'package:flutter/material.dart';



class CommentBloc {
  final _inputController = StreamController<CommentEntity>.broadcast();
  final _resultController = StreamController<CommentResultEntity>.broadcast();

  Stream<CommentResultEntity> get result => _resultController.stream;
  StreamSink<CommentEntity> get fetch => _inputController.sink;

  CommentBloc() {
    _inputController.stream.listen((data) => _set(data));
  }

  void _set(CommentEntity data) async {
    if (data != CommentEntity('')) {
      CommentRepository _getStartAlgRepository = CommentRepository(data);
      CommentResultEntity start = await _getStartAlgRepository.fetchResult();
      _resultController.sink.add(start);
    }
  }

  void dispose() async{
    _inputController.close();
    _resultController.close();
  }
}


class CommentBlocProvider extends InheritedWidget {
  final CommentBloc bloc;

  CommentBlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc
  }) : super(key: key, child: child);

  static CommentBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CommentBlocProvider)
    as CommentBlocProvider).bloc;
  }

  @override
  bool updateShouldNotify(CommentBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
