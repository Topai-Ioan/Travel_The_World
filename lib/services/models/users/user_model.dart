// ignore_for_file: annotate_overrides, overridden_fields

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String username;
  final String name;
  final String bio;
  final String website;
  final String email;
  final String profileUrl;
  final List followers;
  final List following;
  final num totalPosts;

  const UserModel({
    this.uid = '',
    this.username = '',
    this.name = '',
    this.bio = '',
    this.website = '',
    this.email = '',
    this.profileUrl = '',
    this.followers = const [],
    this.following = const [],
    this.totalPosts = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
