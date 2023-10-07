import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String commentId;
  final String postId;
  final String creatorUid;
  final String description;
  final String username;
  final String userProfileUrl;
  final Timestamp createAt;
  final List<String> likes;
  final num totalReplies;

  CommentModel({
    this.commentId = '',
    this.postId = '',
    this.creatorUid = '',
    this.description = '',
    this.username = '',
    this.userProfileUrl = '',
    this.likes = const [],
    this.totalReplies = 0,
  }) : createAt = Timestamp.now();

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
