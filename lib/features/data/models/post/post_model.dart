import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';

class PostModel extends PostEntity {
  @override
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

  PostModel({
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
  }) : super(
          createAt: createAt,
          userUid: userUid,
          description: description,
          likes: likes,
          postId: postId,
          postImageUrl: postImageUrl,
          totalComments: totalComments,
          totalLikes: totalLikes,
          username: username,
          userProfileUrl: userProfileUrl,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      createAt: snapshot['createAt'],
      userUid: snapshot['userUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      postImageUrl: snapshot['postImageUrl'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "userUid": userUid,
        "description": description,
        "userProfileUrl": userProfileUrl,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "postImageUrl": postImageUrl,
        "postId": postId,
        "likes": likes,
        "username": username,
      };
}
