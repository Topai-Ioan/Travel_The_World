// ignore_for_file: annotate_overrides, overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createdAt;
  final List<String>? likes;
  final num? totalReplies;

  const CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createdAt,
    this.likes,
    this.totalReplies,
  }) : super(
            postId: postId,
            creatorUid: creatorUid,
            description: description,
            userProfileUrl: userProfileUrl,
            username: username,
            likes: likes,
            createdAt: createdAt,
            commentId: commentId,
            totalReplies: totalReplies);

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      createdAt: snapshot['createdAt'],
      totalReplies: snapshot['totalReplies'],
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
        "totalReplies": totalReplies,
        "postId": postId,
        "likes": likes,
        "username": username,
      };
}
