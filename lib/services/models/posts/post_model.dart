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
  final String userProfileUrl;

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;

  PostModel({
    this.postId = '',
    this.creatorUid = '',
    this.username = '',
    this.description = '',
    this.postImageUrl = '',
    this.likes = const [],
    this.totalComments = 0,
    this.userProfileUrl = '',
    this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

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