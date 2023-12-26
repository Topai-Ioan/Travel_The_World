import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/firestore/replies/reply_service_interface.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';

class ReplyService implements ReplyServiceInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authService = AuthService();

  @override
  Future<void> createReply({required ReplyModel reply}) async {
    final replyCollection = _db.collection(FirebaseConstants.Reply);
    final newReply = ReplyModel(
            userProfileUrl: reply.userProfileUrl,
            username: reply.username,
            replyId: reply.replyId,
            commentId: reply.commentId,
            postId: reply.postId,
            likes: const [],
            description: reply.description,
            creatorUid: reply.creatorUid,
            createdAt: reply.createdAt)
        .toJson();
    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReply).then((value) {
          final commentCollection =
              _db.collection(FirebaseConstants.Comment).doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              commentCollection
                  .update({"totalReplies": FieldValue.increment(1)});
              return;
            }
          });
        });
      } else {
        replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> deleteReply({required ReplyModel reply}) async {
    final replyCollection = _db.collection(FirebaseConstants.Reply);

    try {
      await replyCollection.doc(reply.replyId).delete();

      final commentCollection =
          _db.collection(FirebaseConstants.Comment).doc(reply.commentId);

      final commentDoc = await commentCollection.get();
      if (commentDoc.exists) {
        await commentCollection
            .update({"totalReplies": FieldValue.increment(-1)});
      }
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  @override
  Future<void> likeReply({required ReplyModel reply}) async {
    final replyCollection = _db.collection(FirebaseConstants.Reply);
    final currentUid = _authService.getCurrentUserId()!;
    final replyRef = await replyCollection.doc(reply.replyId).get();
    if (replyRef.exists) {
      List likes = replyRef.get("likes");
      if (likes.contains(currentUid)) {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyModel>> getReplies({required String commentId}) {
    final ref = _db
        .collection(FirebaseConstants.Reply)
        .where("CommentId", isEqualTo: commentId);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var replies = data.map((d) => ReplyModel.fromJson(d)).toList();
      return replies;
    });
  }

  @override
  Future<void> updateReply({required ReplyModel reply}) async {
    final replyCollection = _db.collection(FirebaseConstants.Reply);

    var data = {
      if (reply.description != '') 'description': reply.description,
      if (reply.description != '') 'edited': true,
      if (reply.userProfileUrl != '') 'userProfileUrl': reply.userProfileUrl,
    };
    replyCollection.doc(reply.replyId).update(data);
  }
}
