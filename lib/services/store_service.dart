import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:uuid/uuid.dart';

class StoreService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, String>> uploadImagePost(
    File? file,
    String childName,
  ) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    String id = const Uuid().v4();
    ref = ref.child(id);

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return {
      "imageId": id,
      "imageUrl": imageUrl,
    };
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
    File? file,
    String childName,
  ) async {
    if (file == null) return '';
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    final uploadTask = ref.putFile(file);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }
}
