import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class UserService implements UserServiceInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<UserModel>> getUser({required String uid}) {
    var ref = _db.collection('Users').where('uid', isEqualTo: uid);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var user = data.map((d) => UserModel.fromJson(d)).toList();
      return user;
    });
  }

  @override
  Future<void> createUser(
      {required UserModel user, required String profileUrl}) async {
    final userCollection = _db.collection(FirebaseConstants.Users);

    final uid = AuthService().getCurrentUserId()!;

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
        followers: user.followers,
        totalPosts: user.totalPosts,
        createdAt: DateTime.now().toUtc(),
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      }
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  Future<void> updateUser({required UserModel user}) {
    var currentUser = AuthService().getCurrentUser()!;
    var ref = _db.collection('Users').doc(currentUser.uid);

    var data = {
      if (user.name != '') 'name': user.name,
      if (user.username != '') 'username': user.username,
      if (user.website != '') 'website': user.website,
      if (user.bio != '') 'bio': user.bio,
      if (user.profileUrl != '') 'profileUrl': user.profileUrl,
    };

    return ref.update(data);
  }

  @override
  Future<String> getUserProfileUrl({required String uid}) async {
    var ref = _db.collection('Users');
    var query = ref.where('uid', isEqualTo: uid);
    var snapshot = await query.get();

    return snapshot.docs.first.data()['profileUrl'] as String;
  }

  @override
  Future<void> followUnFollowUser({required String anoterUserId}) async {
    final userCollection = _db.collection(FirebaseConstants.Users);

    final currentUserId = AuthService().getCurrentUserId();
    final myDocRef = await userCollection.doc(currentUserId).get();
    final otherUserDocRef = await userCollection.doc(anoterUserId).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(anoterUserId)) {
        userCollection.doc(currentUserId).update({
          "following": FieldValue.arrayRemove([anoterUserId])
        });
      } else {
        userCollection.doc(currentUserId).update({
          "following": FieldValue.arrayUnion([anoterUserId])
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(currentUserId)) {
        userCollection.doc(anoterUserId).update({
          "followers": FieldValue.arrayRemove([currentUserId])
        });
      } else {
        userCollection.doc(anoterUserId).update({
          "followers": FieldValue.arrayUnion([currentUserId])
        });
      }
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String text) async {
    var ref = _db
        .collection('Users')
        .orderBy('username')
        .startAt([text]).endAt(['$text\uf8ff']);
    var snapshot = await ref.get();
    var users =
        snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    return users;
  }
}
