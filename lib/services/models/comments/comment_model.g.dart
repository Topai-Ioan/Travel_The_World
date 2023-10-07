// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      commentId: json['commentId'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      creatorUid: json['creatorUid'] as String? ?? '',
      description: json['description'] as String? ?? '',
      username: json['username'] as String? ?? '',
      userProfileUrl: json['userProfileUrl'] as String? ?? '',
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      totalReplies: json['totalReplies'] as num? ?? 0,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'postId': instance.postId,
      'creatorUid': instance.creatorUid,
      'description': instance.description,
      'username': instance.username,
      'userProfileUrl': instance.userProfileUrl,
      'likes': instance.likes,
      'totalReplies': instance.totalReplies,
    };
