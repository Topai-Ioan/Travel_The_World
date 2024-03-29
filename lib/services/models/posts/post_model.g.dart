// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      postId: json['postId'] as String? ?? '',
      creatorUid: json['creatorUid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      description: json['description'] as String? ?? '',
      postImageUrl: json['postImageUrl'] as String? ?? '',
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryConfidence: (json['categoryConfidence'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      totalComments: json['totalComments'] as num? ?? 0,
      userProfileUrl: json['userProfileUrl'] as String? ?? '',
      createdAt:
          PostModel._timestampToDateTime(json['createdAt'] as Timestamp?),
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? -1,
      longitude: (json['longitude'] as num?)?.toDouble() ?? -1,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'postId': instance.postId,
      'creatorUid': instance.creatorUid,
      'username': instance.username,
      'description': instance.description,
      'postImageUrl': instance.postImageUrl,
      'likes': instance.likes,
      'category': instance.category,
      'categoryConfidence': instance.categoryConfidence,
      'totalComments': instance.totalComments,
      'userProfileUrl': instance.userProfileUrl,
      'country': instance.country,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': PostModel._dateTimeToTimestamp(instance.createdAt),
    };
