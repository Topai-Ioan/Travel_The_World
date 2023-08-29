import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? creatorUid;
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createAt;

  const ReplyEntity({
    this.creatorUid,
    this.replyId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.likes,
    this.createAt,
  });

  @override
  List<Object?> get props => [
        creatorUid,
        replyId,
        commentId,
        postId,
        description,
        username,
        userProfileUrl,
        likes,
        createAt,
      ];
}
