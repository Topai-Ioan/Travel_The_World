import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/models/user/user_model.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';

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
  Future<void> createUser(UserEntity user, String profileUrl) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.Users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
              uid: uid,
              name: user.name,
              email: user.email,
              bio: user.bio,
              following: user.following,
              website: user.website,
              profileUrl: profileUrl,
              username: user.username,
              totalFollowers: user.totalFollowers,
              followers: user.followers,
              totalFollowing: user.totalFollowing,
              totalPosts: user.totalPosts)
          .toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      print(error.toString());
      toast("Some error occur");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConstants.Users)
        .where("uid", isEqualTo: uid);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.Users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print("fields cannot be empty");
      }
    } on FirebaseAuthException catch (_) {
      //todo log exceptions

      toast("Invalid credentials");
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.imageFile != null) {
            // todo dont hardcode it here
            uploadImage(user.imageFile, "ProfileImages", isPost: false)
                .then((profileUrl) {
              createUser(user, profileUrl);
            });
          } else {
            createUser(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.Users);
    Map<String, dynamic> userInformation = {};

    if (user.username != "" && user.username != null) {
      userInformation['username'] = user.username;
    }

    if (user.website != "" && user.website != null) {
      userInformation['website'] = user.website;
    }

    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.bio != "" && user.bio != null) {
      userInformation['bio'] = user.bio;
    }

    if (user.name != "" && user.name != null) {
      userInformation['name'] = user.name;
    }

    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImage(File? file, String childName,
      {bool isPost = true}) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().minute}';

      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }
}
