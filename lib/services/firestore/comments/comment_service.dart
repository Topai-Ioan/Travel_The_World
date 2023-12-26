import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/firestore/comments/comment_service_interface.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';

class CommentService implements CommentServiceInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authService = AuthService();
  @override
  Future<void> createComment({required CommentModel comment}) async {
    final commentCollection = _db.collection(FirebaseConstants.Comment);

    final newComment = CommentModel(
            userProfileUrl: comment.userProfileUrl,
            username: comment.username,
            totalReplies: comment.totalReplies,
            commentId: comment.commentId,
            postId: comment.postId,
            likes: const [],
            description: comment.description,
            creatorUid: comment.creatorUid,
            createdAt: comment.createdAt)
        .toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection =
              _db.collection(FirebaseConstants.Posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              postCollection.update({"totalComments": FieldValue.increment(1)});
              return;
            }
          });
        });
      }
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    final commentCollection = _db.collection(FirebaseConstants.Comment);
    final comment = await getCommentById(commentId: commentId);
    try {
      if (comment.creatorUid == _authService.getCurrentUserId()) {
        await commentCollection.doc(commentId).delete();

        final postCollection =
            _db.collection(FirebaseConstants.Posts).doc(comment.postId);

        final postDoc = await postCollection.get();
        if (postDoc.exists) {
          await postCollection
              .update({"totalComments": FieldValue.increment(-1)});
        }

        final commentDoc = await commentCollection.doc(commentId).get();
        final totalReplies = commentDoc.data()?['totalReplies'];

        if (totalReplies != 0) {
          final replyCollection = _db.collection(FirebaseConstants.Reply);

          final repliesQuery = await replyCollection
              .where('commentId', isEqualTo: commentId)
              .get();

          for (final replyDoc in repliesQuery.docs) {
            await replyDoc.reference.delete();
          }
        }
      }
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  @override
  Future<void> likeComment({required CommentModel comment}) async {
    final commentCollection = _db.collection(FirebaseConstants.Comment);
    final currentUid = _authService.getCurrentUserId();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentModel>> getComments({required String postId}) {
    final ref = _db
        .collection(FirebaseConstants.Comment)
        .where("postId", isEqualTo: postId);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var comment = data.map((d) => CommentModel.fromJson(d)).toList();
      return comment;
    });
  }

  @override
  Future<CommentModel> getCommentById({required String commentId}) async {
    final commentDoc =
        await _db.collection(FirebaseConstants.Comment).doc(commentId).get();

    if (commentDoc.exists) {
      final commentData = commentDoc.data();
      if (commentData != null) {
        return CommentModel.fromJson(commentData);
      }
    }

    return CommentModel(
      commentId: commentId,
    );
  }

  @override
  Future<void> editComment({required CommentModel comment}) async {
    final ref = _db.collection(FirebaseConstants.Comment);

    var data = {
      if (comment.description != '') 'description': comment.description,
      if (comment.description != '') 'edited': true,
      if (comment.userProfileUrl != '')
        'userProfileUrl': comment.userProfileUrl,
    };

    return ref.doc(comment.commentId).update(data);
  }
}
