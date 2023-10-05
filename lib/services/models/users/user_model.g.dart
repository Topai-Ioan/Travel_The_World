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
      followers: json['followers'] as List<dynamic>? ?? const [],
      following: json['following'] as List<dynamic>? ?? const [],
      totalPosts: json['totalPosts'] as num? ?? 0,
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
    };
