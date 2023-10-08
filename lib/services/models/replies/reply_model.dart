import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reply_model.g.dart';

@JsonSerializable()
class ReplyModel {
  final String creatorUid;
  final String replyId;
  final String commentId;
  final String postId;
  final String description;
  final String username;
  final String userProfileUrl;
  final List<String> likes;

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;

  const ReplyModel({
    this.creatorUid = '',
    this.replyId = '',
    this.commentId = '',
    this.postId = '',
    this.description = '',
    this.username = '',
    this.userProfileUrl = '',
    this.likes = const [],
    this.createdAt,
  });
  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyModelToJson(this);

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
