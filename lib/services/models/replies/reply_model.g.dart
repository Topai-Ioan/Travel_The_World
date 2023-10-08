// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) => ReplyModel(
      creatorUid: json['creatorUid'] as String? ?? '',
      replyId: json['replyId'] as String? ?? '',
      commentId: json['commentId'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      username: json['username'] as String? ?? '',
      userProfileUrl: json['userProfileUrl'] as String? ?? '',
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt:
          ReplyModel._timestampToDateTime(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$ReplyModelToJson(ReplyModel instance) =>
    <String, dynamic>{
      'creatorUid': instance.creatorUid,
      'replyId': instance.replyId,
      'commentId': instance.commentId,
      'postId': instance.postId,
      'description': instance.description,
      'username': instance.username,
      'userProfileUrl': instance.userProfileUrl,
      'likes': instance.likes,
      'createdAt': ReplyModel._dateTimeToTimestamp(instance.createdAt),
    };
