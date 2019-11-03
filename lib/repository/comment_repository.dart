import 'package:dio/dio.dart';
import 'package:emo_tv/constants/endpoint_constants.dart';
import 'package:emo_tv/constants/exception_constants.dart';
import 'package:emo_tv/entities/comment_entity.dart';


class CommentRepository{
  CommentEntity comment = CommentEntity('');

  CommentRepository(this.comment);

  Future<CommentResultEntity> fetchResult(){
    final CommentProvider _fetchAlgResultProvider = CommentProvider(comment.get());
    return _fetchAlgResultProvider.fetchResult();
  }
}

class CommentProvider{
  final String _endpoint = EC.TONE_URL;
  final Dio _dio = Dio();
  Map post = CommentEntity('').get();

  CommentProvider(this.post);

  Future<CommentResultEntity> fetchResult() async {
    if (post != CommentEntity('').get()) {
      Response response = await _dio.post(_endpoint, data: post);
      if (response.statusCode == 200) {
//        return CommentResultEntity.fromJson(response.data);
      return CommentResultEntity('calm');
      } else {
        throw Exception(ExC.fetchResultServerError);
      }
    } else {
      throw Exception(ExC.fetchResultInputError);
    }
  }

}
