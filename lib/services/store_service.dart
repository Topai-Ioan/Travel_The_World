import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:uuid/uuid.dart';

class ImageUploadResult {
  final String imageId;
  final String imageUrl;

  ImageUploadResult({
    required this.imageId,
    required this.imageUrl,
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
      if (file == null) {
        return ImageUploadResult(
          imageId: '',
          imageUrl: '',
        );
      }

      Reference ref = firebaseStorage
          .ref()
          .child(childName)
          .child(firebaseAuth.currentUser!.uid);

      String id = const Uuid().v4();
      ref = ref.child(id);

      final uploadTask = ref.putFile(file);

      final imageUrl =
          await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

      return ImageUploadResult(
        imageId: id,
        imageUrl: imageUrl,
      );
    } catch (e) {
      toast("Error uploading image");
    }
    return ImageUploadResult(
      imageId: '',
      imageUrl: '',
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
      Reference ref = firebaseStorage
          .ref()
          .child(childName)
          .child(firebaseAuth.currentUser!.uid);

      final uploadTask = ref.putFile(file);

      final imageUrl =
          (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

      return await imageUrl;
    } catch (e) {
      toast("Error uploading profile picture");
      return '';
    }
  }
}
