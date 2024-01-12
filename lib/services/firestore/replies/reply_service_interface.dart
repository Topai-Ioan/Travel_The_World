import 'package:travel_the_world/services/models/replies/reply_model.dart';

abstract class ReplyServiceInterface {
  Future<void> createReply({required ReplyModel reply});
  Future<void> deleteReply({required ReplyModel reply});
  Future<void> likeReply({required ReplyModel reply});
  Stream<List<ReplyModel>> getReplies({required String commentId});
  Future<void> updateReply({required ReplyModel reply});
}
