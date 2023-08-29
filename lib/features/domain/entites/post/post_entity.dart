import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? userUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  const PostEntity({
    this.postId,
    this.userUid,
    this.username,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  });

  @override
  List<Object?> get props => [
        postId,
        userUid,
        username,
        description,
        postImageUrl,
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
