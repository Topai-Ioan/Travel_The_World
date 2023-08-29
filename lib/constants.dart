// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backgroundColor = Color.fromRGBO(0, 0, 0, 1.0);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1);
const greenColor = Colors.green;

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
}

class FirebaseConstants {
  static const String Users = "Users";
  static const String Posts = "Posts";
  static const String Comment = "Comment";
  static const String Replay = "Replay";
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blueColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
