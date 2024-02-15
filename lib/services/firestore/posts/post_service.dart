import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class PostService implements PostServiceInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _authService = AuthService();
  @override
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

  @override
  Future<void> deletePost({required String postId}) async {
    final postCollection = _db.collection(FirebaseConstants.Posts);

    try {
      final postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        final creatorUid = postDoc.data()!['creatorUid'];
        final userCollection =
            _db.collection(FirebaseConstants.Users).doc(creatorUid);

        final userDoc = await userCollection.get();
        if (userDoc.exists) {
          await userCollection.update({"totalPosts": FieldValue.increment(-1)});
        }

        postCollection.doc(postId).delete();

        final imageId = postId;
        final storageRef = _firebaseStorage
            .ref()
            .child("Posts")
            .child(_authService.getCurrentUserId()!)
            .child(imageId);
        await storageRef.delete();

        final totalComments = postDoc.data()!['totalComments'];
        if (totalComments != 0) {
          final commentCollection = _db.collection(FirebaseConstants.Comment);

          final commentsQuery =
              await commentCollection.where('postId', isEqualTo: postId).get();

          for (final commentDoc in commentsQuery.docs) {
            final totalReplies = commentDoc.data()['totalReplies'];

            if (totalReplies != 0) {
              final replyCollection = _db.collection(FirebaseConstants.Reply);
              final repliesQuery = await replyCollection
                  .where('commentId', isEqualTo: commentDoc.id)
                  .get();

              for (final replyDoc in repliesQuery.docs) {
                await replyDoc.reference.delete();
              }
            }
            await commentDoc.reference.delete();
          }
        }
      } else {
        toast("Post does not exist.");
      }
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  @override
  Future<void> updatePost({required PostModel post}) async {
    final ref = _db.collection(FirebaseConstants.Posts).doc(post.postId);

    var data = {
      if (post.description != '') 'description': post.description,
      if (post.postImageUrl != '') 'postImageUrl': post.postImageUrl,
      if (post.userProfileUrl != '') 'userProfileUrl': post.userProfileUrl,
    };
    return ref.update(data);
  }

  @override
  Future<void> likePost({required String postId}) async {
    final postCollection = _db.collection(FirebaseConstants.Posts);

    final currentUid = AuthService().getCurrentUserId()!;
    final postRef = await postCollection.doc(postId).get();

    //todo dont hardcode strings
    if (postRef.exists) {
      List likes = postRef.get("likes");
      if (likes.contains(currentUid)) {
        postCollection.doc(postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
        });
      } else {
        postCollection.doc(postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Future<List<PostModel>> getPost({required String postId}) async {
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .where("postId", isEqualTo: postId)
        .orderBy("createdAt", descending: true);

    var querySnapshot = await ref.get();
    var data = querySnapshot.docs.map((doc) => doc.data()).toList();
    var post = data.map((d) => PostModel.fromJson(d)).toList();
    return post;
  }

  @override
  Future<List<PostModel>> getPosts() async {
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .orderBy("createdAt", descending: true);

    var querySnapshot = await ref.get();
    var data = querySnapshot.docs.map((doc) => doc.data()).toList();
    var posts = data.map((d) => PostModel.fromJson(d)).toList();
    return posts;
  }

  @override
  Future<List<PostModel>> getPostsFiltered(String text) async {
    text = text.toLowerCase();
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .orderBy("createdAt", descending: true);

    var querySnapshot = await ref.get();
    var posts = <PostModel>[];

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      var category = (data['category'] as List<dynamic>)
          .cast<String>()
          .map((tag) => tag.toLowerCase())
          .toList();

      var addedPhotoIDs = <String>{};
      for (var tag in category) {
        if (tag.contains(text) || tag.startsWith(text)) {
          var postModel = PostModel.fromJson(data);
          if (!addedPhotoIDs.contains(postModel.postId)) {
            posts.add(postModel);
            addedPhotoIDs.add(postModel.postId);
          }
        }
      }
    }
    return posts;
  }

  @override
  Future<List<PostModel>> getPostsFromFollowedUsersInTheLast24h(
      {required UserModel currentUser}) async {
    final followingList = List<String>.from(currentUser.following);
    if (!followingList.contains(currentUser.uid)) {
      followingList.add(currentUser.uid);
    }

    final twentyFourHoursAgo =
        DateTime.now().subtract(const Duration(hours: 24));
    final ref = _db
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', whereIn: followingList)
        .where('createdAt', isGreaterThan: twentyFourHoursAgo)
        .orderBy("createdAt", descending: true);

    var querySnapshot = await ref.get();
    var data = querySnapshot.docs.map((doc) => doc.data()).toList();
    var posts = data.map((d) => PostModel.fromJson(d)).toList();
    return posts;
  }

  @override
  Future<void> addCategoryAndDimensions({required PostModel post}) async {
    final ref = _db.collection(FirebaseConstants.Posts).doc(post.postId);

    final lowercasecategory =
        post.category.map((tag) => tag.toLowerCase()).toList();

    var data = {
      if (lowercasecategory.isNotEmpty) 'category': lowercasecategory,
      if (post.categoryConfidence.isNotEmpty)
        'categoryConfidence': post.categoryConfidence,
      if (post.width != 0) 'weight': post.width,
      if (post.height != 0) 'height': post.height,
    };

    return ref.update(data);
  }
}
