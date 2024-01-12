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
  final List<String> likes;
  final num totalReplies;
  final bool edited;

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;

  CommentModel({
    this.commentId = '',
    this.postId = '',
    this.creatorUid = '',
    this.description = '',
    this.username = '',
    this.userProfileUrl = '',
    this.likes = const [],
    this.totalReplies = 0,
    this.edited = false,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

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
