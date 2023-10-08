import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/auth_service.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authService = AuthService();

  Future<void> createComment(CommentModel comment) async {
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

  Future<void> deleteComment(CommentModel comment) async {
    final commentCollection = _db.collection(FirebaseConstants.Comment);

    try {
      if (comment.creatorUid == _authService.getCurrentUserId()) {
        commentCollection.doc(comment.commentId).delete().then((value) {
          final postCollection =
              _db.collection(FirebaseConstants.Posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              postCollection
                  .update({"totalComments": FieldValue.increment(-1)});
              return;
            }
          });
        });
      }
    } catch (e) {
      toast("some error occured $e");
    }
  }

  Future<void> likeComment(CommentModel comment) async {
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

  Stream<List<CommentModel>> getComments(String postId) {
    final ref = _db
        .collection(FirebaseConstants.Comment)
        .where("postId", isEqualTo: postId);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var comment = data.map((d) => CommentModel.fromJson(d)).toList();
      return comment;
    });
  }

  Future<void> editComment(CommentModel comment) async {
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
