import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String postId;
  final String creatorUid;
  final String username;
  final String description;
  final String postImageUrl;
  final List<String> likes;
  final num totalComments;
  final Timestamp createdAt;
  final String userProfileUrl;

  PostModel({
    this.postId = '',
    this.creatorUid = '',
    this.username = '',
    this.description = '',
    this.postImageUrl = '',
    this.likes = const [],
    this.totalComments = 0,
    this.userProfileUrl = '',
  }) : createdAt = Timestamp.now();

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
