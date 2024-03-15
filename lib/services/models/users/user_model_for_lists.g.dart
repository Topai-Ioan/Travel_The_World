// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_for_lists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelForLists _$UserModelForListsFromJson(Map<String, dynamic> json) =>
    UserModelForLists(
      uid: json['uid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      profileUrl: json['profileUrl'] as String? ?? '',
    );

Map<String, dynamic> _$UserModelForListsToJson(UserModelForLists instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'profileUrl': instance.profileUrl,
    };
