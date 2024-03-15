import 'package:json_annotation/json_annotation.dart';

part 'user_model_for_lists.g.dart';

@JsonSerializable()
class UserModelForLists {
  final String uid;
  final String username;
  final String profileUrl;

  UserModelForLists({
    this.uid = '',
    this.username = '',
    this.profileUrl = '',
  });

  factory UserModelForLists.fromJson(Map<String, dynamic> json) =>
      _$UserModelForListsFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelForListsToJson(this);
}
