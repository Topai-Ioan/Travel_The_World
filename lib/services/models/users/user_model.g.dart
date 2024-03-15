// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileUrl: json['profileUrl'] as String? ?? '',
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalPosts: json['totalPosts'] as num? ?? 0,
      createdAt:
          UserModel._timestampToDateTime(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'name': instance.name,
      'bio': instance.bio,
      'website': instance.website,
      'email': instance.email,
      'profileUrl': instance.profileUrl,
      'followers': instance.followers,
      'following': instance.following,
      'totalPosts': instance.totalPosts,
      'createdAt': UserModel._dateTimeToTimestamp(instance.createdAt),
    };
