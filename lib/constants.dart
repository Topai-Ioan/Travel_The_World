// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget sizeVertical(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHorizontal(double width) {
  return SizedBox(
    width: width,
  );
}

class PageRoutes {
  static const String MainPage = "/";
  static const String EditProfilePage = "EditProfilePage";
  static const String UpdatePostPage = "UpdatePostPage";
  static const String CommentPage = "CommentPage";
  static const String SignInPage = "SignInPage";
  static const String SignUpPage = "SignUpPage";
  static const String UpdateCommentPage = "UpdateCommentPage";
  static const String UpdateReplyPage = "UpdateReplyPage";
  static const String PostDetailPage = "PostDetailPage";
  static const String SingleUserProfilePage = "SingleUserProfilePage";
  static const String FollowingPage = "FollowingPage";
  static const String FollowersPage = "FollowersPage";
  static const String LikeListPage = "LikeListPage";
  static const String SettingsPage = "SettingsPage";
}

class FirebaseConstants {
  static const String Users = "Users";
  static const String Posts = "Posts";
  static const String Comment = "Comment";
  static const String Reply = "Reply";
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 14.0);
}
