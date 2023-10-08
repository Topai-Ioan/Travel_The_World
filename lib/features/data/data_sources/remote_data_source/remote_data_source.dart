import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/models/reply/reply_model.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class FirebaseRemoteDataSource implements FirebaseRemoteDataSourceInterface {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSource({
    required this.firebaseStorage,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<Map<String, String>> uploadImagePost(
    File? file,
    String childName,
  ) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    String id = const Uuid().v4();
    ref = ref.child(id);

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return {
      "imageId": id,
      "imageUrl": imageUrl,
    };
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);
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
          final commentCollection = firebaseFirestore
              .collection(FirebaseConstants.Comment)
              .doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalreplies = value.get('totalReplies');
              commentCollection.update({"totalReplies": totalreplies + 1});
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
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    try {
      replyCollection.doc(reply.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConstants.Comment)
            .doc(reply.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplies = value.get('totalReplies');
            commentCollection.update({"totalReplies": totalReplies - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);
    final currentUid = AuthService().getCurrentUserId()!;
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
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply) {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    Map<String, dynamic> replyInfo = {};
    if (reply.description != "" && reply.description != null) {
      replyInfo['description'] = reply.description;
    }

    if (reply.userProfileUrl != "" && reply.userProfileUrl != null) {
      replyInfo['userProfileUrl'] = reply.userProfileUrl;
    }

    replyCollection.doc(reply.replyId).update(replyInfo);
  }

  @override
  Future<void> syncProfilePicture(String profileUrl) async {
    //posts
    final userPostsQuery = firebaseFirestore
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userPostsDocuments = await userPostsQuery.get();

    for (final post in userPostsDocuments.docs) {
      await post.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
    //coments
    final userCommentsQuery = firebaseFirestore
        .collection(FirebaseConstants.Comment)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userCommentsDocuments = await userCommentsQuery.get();

    for (final comment in userCommentsDocuments.docs) {
      await comment.reference.update({
        'userProfileUrl': profileUrl,
      });
    }

    //replies
    final userRepliesQuery = firebaseFirestore
        .collection(FirebaseConstants.Reply)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userRepliesDocuments = await userRepliesQuery.get();

    for (final reply in userRepliesDocuments.docs) {
      await reply.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
  }
}
