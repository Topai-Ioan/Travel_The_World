import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:uuid/uuid.dart';

class FirebaseRemoteDataSource implements FirebaseRemoteDataSourceInterface {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSource({
    required this.firebaseStorage,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
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

  @override
  Future<void> syncProfilePicture(String profileUrl) async {
    //posts
    final userPostsQuery = firebaseFirestore
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userPostsDocuments = await userPostsQuery.get();

    for (final post in userPostsDocuments.docs) {
      await post.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
    //coments
    final userCommentsQuery = firebaseFirestore
        .collection(FirebaseConstants.Comment)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userCommentsDocuments = await userCommentsQuery.get();

    for (final comment in userCommentsDocuments.docs) {
      await comment.reference.update({
        'userProfileUrl': profileUrl,
      });
    }

    //replies
    final userRepliesQuery = firebaseFirestore
        .collection(FirebaseConstants.Reply)
        .where('creatorUid', isEqualTo: firebaseAuth.currentUser!.uid);

    final userRepliesDocuments = await userRepliesQuery.get();

    for (final reply in userRepliesDocuments.docs) {
      await reply.reference.update({
        'userProfileUrl': profileUrl,
      });
    }
  }
}
