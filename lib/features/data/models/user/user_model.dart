// ignore_for_file: annotate_overrides, overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? name;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalPosts;

  const UserModel({
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalPosts,
  }) : super(
          uid: uid,
          followers: followers,
          username: username,
          profileUrl: profileUrl,
          website: website,
          following: following,
          bio: bio,
          name: name,
          email: email,
          totalPosts: totalPosts,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      name: snapshot['name'],
      bio: snapshot['bio'],
      username: snapshot['username'],
      totalPosts: snapshot['totalPosts'],
      website: snapshot['website'],
      profileUrl: snapshot['profileUrl'],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "username": username,
        "totalPosts": totalPosts,
        "website": website,
        "bio": bio,
        "profileUrl": profileUrl,
        "followers": followers,
        "following": following,
      };
}
