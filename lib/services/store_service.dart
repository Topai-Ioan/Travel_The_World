import 'dart:io';

import 'package:image/image.dart' as img;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUploadResult {
  final String imageId;
  final String imageUrl;
  final double width;
  final double height;

  ImageUploadResult({
    required this.imageId,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
}

class StoreService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<ImageUploadResult> uploadImagePost(
    File? file,
    String childName,
  ) async {
    try {
      img.Image? originalImage = img.decodeImage(file!.readAsBytesSync());
      double originalWidth = (originalImage?.width ?? 0).toDouble();
      double originalHeight = (originalImage?.height ?? 0).toDouble();
      double aspectRatio = originalWidth / originalHeight;

      int targetWidth = 400;
      int targetHeight = (targetWidth / aspectRatio).round();
      final result = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 75,
        minHeight: targetHeight,
        minWidth: targetWidth,
      );
      final compressedFile = File(file.path)
        ..writeAsBytesSync(result!.toList());

      img.Image? image = img.decodeImage(file.readAsBytesSync());
      double width = (image?.width ?? 0).toDouble();
      double height = (image?.height ?? 0).toDouble();

      Reference ref = firebaseStorage
          .ref()
          .child(childName)
          .child(firebaseAuth.currentUser!.uid);

      String id = const Uuid().v4();
      ref = ref.child(id);

      final uploadTask = ref.putFile(compressedFile);

      final imageUrl =
          await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

      return ImageUploadResult(
        imageId: id,
        imageUrl: imageUrl,
        width: width,
        height: height,
      );
    } catch (e) {
      toast("Error uploading image");
    }
    return ImageUploadResult(
      imageId: '',
      imageUrl: '',
      width: 0,
      height: 0,
    );
  }

  Future<void> syncProfilePicture(String profileUrl) async {
    //posts
    final userPostsQuery = _db
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userPostsDocuments = await userPostsQuery.get();

    for (final post in userPostsDocuments.docs) {
      await post.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
    //coments
    final userCommentsQuery = _db
        .collection(FirebaseConstants.Comment)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userCommentsDocuments = await userCommentsQuery.get();

    for (final comment in userCommentsDocuments.docs) {
      await comment.reference.update({
        'userProfileUrl': profileUrl,
      });
    }

    //replies
    final userRepliesQuery = _db
        .collection(FirebaseConstants.Reply)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userRepliesDocuments = await userRepliesQuery.get();

    for (final reply in userRepliesDocuments.docs) {
      await reply.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
  }

  Future<String> uploadImageProfilePicture(
    File file,
    String childName,
  ) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 75,
      );
      final compressedFile = File(file.path)
        ..writeAsBytesSync(result!.toList());

      Reference ref = firebaseStorage
          .ref()
          .child(childName)
          .child(firebaseAuth.currentUser!.uid);

      final uploadTask = ref.putFile(compressedFile);

      final imageUrl =
          (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

      return await imageUrl;
    } catch (e) {
      toast("Error uploading profile picture");
      return '';
    }
  }
}
