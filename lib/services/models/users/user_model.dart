import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String password;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? imageFile;

  UserModel({
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
    this.password = '',
    this.imageFile,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static DateTime? _timestampToDateTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return null;
    }
    return timestamp.toDate();
  }

  static Timestamp? _dateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return Timestamp.fromDate(dateTime);
  }
}
