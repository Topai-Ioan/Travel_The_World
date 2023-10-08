import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/auth_service.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _authService = AuthService();

  Future<void> createPost({required PostModel post}) async {
    final postCollection = _db.collection(FirebaseConstants.Posts);

    final newPost = PostModel(
      userProfileUrl: post.userProfileUrl,
      username: post.username,
      totalComments: 0,
      postImageUrl: post.postImageUrl,
      postId: post.postId,
      likes: const [],
      description: post.description,
      creatorUid: post.creatorUid,
      createdAt: DateTime.now().toUtc(),
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection =
              _db.collection(FirebaseConstants.Users).doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              userCollection.update({"totalPosts": FieldValue.increment(1)});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      toast("Some error occurred $e");
    }
  }

  Future<void> deletePost({required PostModel post}) async {
    final postCollection = _db.collection(FirebaseConstants.Posts);

    try {
      final postDoc = await postCollection.doc(post.postId).get();
      if (postDoc.exists) {
        final creatorUid = postDoc.data()!['creatorUid'];
        final userCollection =
            _db.collection(FirebaseConstants.Users).doc(creatorUid);

        final userDoc = await userCollection.get();
        if (userDoc.exists) {
          await userCollection.update({"totalPosts": FieldValue.increment(-1)});
        }

        postCollection.doc(post.postId).delete();

        final imageId = post.postId;
        final storageRef = _firebaseStorage
            .ref()
            .child("Posts")
            .child(_authService.getCurrentUserId()!)
            .child(imageId);
        await storageRef.delete();
      } else {
        toast("Post does not exist.");
      }
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  Future<void> likePost({required PostModel post}) async {
    final postCollection = _db.collection(FirebaseConstants.Posts);

    final currentUid = AuthService().getCurrentUserId()!;
    final postRef = await postCollection.doc(post.postId).get();

    //todo dont hardcode strings
    if (postRef.exists) {
      List likes = postRef.get("likes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  Stream<List<PostModel>> getPost({required String postId}) {
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .where("postId", isEqualTo: postId)
        .orderBy("createdAt", descending: true);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var post = data.map((d) => PostModel.fromJson(d)).toList();
      return post;
    });
  }

  Stream<List<PostModel>> getPosts() {
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .orderBy("createdAt", descending: true);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var posts = data.map((d) => PostModel.fromJson(d)).toList();
      return posts;
    });
  }

  Future<Stream<List<PostModel>>> getPostsFromFollowedUsers(
      {required UserModel currentUser}) async {
    final followingList = List<String>.from(currentUser.following);
    if (!followingList.contains(currentUser.uid)) {
      followingList.add(currentUser.uid);
    }
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', whereIn: followingList)
        .orderBy("createdAt", descending: true);

    return ref.snapshots().map((querySnapshot) {
      var data = querySnapshot.docs.map((doc) => doc.data());
      var posts = data.map((d) => PostModel.fromJson(d)).toList();
      return posts;
    });
  }

  Future<void> updatePost({required PostModel post}) async {
    final ref = _db.collection(FirebaseConstants.Posts).doc(post.postId);

    var data = {
      if (post.description != '') 'description': post.description,
      if (post.postImageUrl != '') 'postImageUrl': post.postImageUrl,
      if (post.userProfileUrl != '') 'userProfileUrl': post.userProfileUrl,
    };
    return ref.update(data);
  }
}
