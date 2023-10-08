// ignore_for_file: annotate_overrides, overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  final String? creatorUid;
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createdAt;

  const ReplyModel({
    this.creatorUid,
    this.replyId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.likes,
    this.createdAt,
  }) : super(
            description: description,
            commentId: commentId,
            postId: postId,
            creatorUid: creatorUid,
            userProfileUrl: userProfileUrl,
            username: username,
            likes: likes,
            createdAt: createdAt,
            replyId: replyId);

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      replyId: snapshot['replyId'],
      createdAt: snapshot['createdAt'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() => {
        "creatorUid": creatorUid,
        "description": description,
        "userProfileUrl": userProfileUrl,
        "commentId": commentId,
        "createdAt": createdAt,
        "replyId": replyId,
        "postId": postId,
        "likes": likes,
        "username": username,
      };
}
