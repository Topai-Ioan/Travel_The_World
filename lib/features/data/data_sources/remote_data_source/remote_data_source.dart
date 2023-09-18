import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/models/comment/comment_model.dart';
import 'package:travel_the_world/features/data/models/post/post_model.dart';
import 'package:travel_the_world/features/data/models/reply/reply_model.dart';
import 'package:travel_the_world/features/data/models/user/user_model.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
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
              followers: user.followers,
              totalPosts: user.totalPosts)
          .toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast(error.toString());
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
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.Users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayRemove([user.otherUid])
        });
      } else {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayUnion([user.otherUid])
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(user.uid)) {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayRemove([user.uid])
        });
      } else {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayUnion([user.uid])
        });
      }
    }
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConstants.Users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
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
            email: user.email!.replaceAll(" ", ""), password: user.password!);
      } else {
        toast("fields cannot be empty");
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
    final passwordPattern = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>])[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{8,}$');

    if (!passwordPattern.hasMatch(user.password!)) {
      toast(
          "Password must contain at least one uppercase letter, one lowercase letter, one number, one special character, and be at least 8 characters long.");
      return;
    }

    if (!user.password!
        .contains(RegExp(r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>]+$'))) {
      toast("Only English characters allowed");
      return;
    }

    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!.replaceAll(" ", ""), password: user.password!)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.imageFile != null) {
            // todo don't hardcode it here
            uploadImageProfilePicture(user.imageFile, "ProfileImages")
                .then((profileUrl) {
              createUser(user, profileUrl);
            });
          } else {
            createUser(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (_) {
      toast("Something went wrong");
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.Users);
    Map<String, dynamic> userInformation = {};

    if (user.email != "" && user.email != null) {
      userInformation['email'] = user.email;
    }

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

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageProfilePicture(
    File? file,
    String childName,
  ) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

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
  Future<void> createPost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.Posts);

    final newPost = PostModel(
            userProfileUrl: post.userProfileUrl,
            username: post.username,
            totalLikes: 0,
            totalComments: 0,
            postImageUrl: post.postImageUrl,
            postId: post.postId,
            likes: const [],
            description: post.description,
            creatorUid: post.creatorUid,
            createAt: post.createAt)
        .toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConstants.Users)
              .doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
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
  Future<void> deletePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.Posts);

    try {
      final postDoc = await postCollection.doc(post.postId).get();
      if (postDoc.exists) {
        final creatorUid = postDoc.data()?['creatorUid'];
        final userCollection = firebaseFirestore
            .collection(FirebaseConstants.Users)
            .doc(creatorUid);

        final userDoc = await userCollection.get();
        if (userDoc.exists) {
          final totalPosts = userDoc.data()?['totalPosts'];

          await userCollection.update({"totalPosts": totalPosts - 1});
        }

        postCollection.doc(post.postId).delete();

        final imageId = post.postId!;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("Posts")
            .child(firebaseAuth.currentUser!.uid)
            .child(imageId);
        await storageRef.delete();
      } else {
        toast("Post does not exist.");
      }
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.Posts);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    //todo dont hardcode strings
    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.Posts)
        .where("postId", isEqualTo: postId)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readPosts() {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.Posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<Stream<List<PostEntity>>> readPostsFromFollowedUsers(
      UserEntity currentUser) async {
    final followingList = List<String>.from(currentUser.following ?? []);
    if (!followingList.contains(currentUser.uid)) {
      followingList.add(currentUser.uid!);
    }
    final posts = firebaseFirestore
        .collection(FirebaseConstants.Posts)
        .where('creatorUid', whereIn: followingList)
        .orderBy("createAt", descending: true);

    return posts.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.Posts);
    Map<String, dynamic> postInfo = {};

    if (post.description != "" && post.description != null) {
      postInfo['description'] = post.description;
    }
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }
    if (post.userProfileUrl != "" && post.userProfileUrl != null) {
      postInfo['userProfileUrl'] = post.userProfileUrl;
    }

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConstants.Comment);

    final newComment = CommentModel(
            userProfileUrl: comment.userProfileUrl,
            username: comment.username,
            totalReplies: comment.totalReplies,
            commentId: comment.commentId,
            postId: comment.postId,
            likes: const [],
            description: comment.description,
            creatorUid: comment.creatorUid,
            createAt: comment.createAt)
        .toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConstants.Posts)
              .doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      }
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConstants.Comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConstants.Posts)
            .doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConstants.Comment);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.Comment)
        .where("postId", isEqualTo: postId);

    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConstants.Comment);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" && comment.description != null) {
      commentInfo["description"] = comment.description;
    }
    if (comment.userProfileUrl != "" && comment.userProfileUrl != null) {
      commentInfo['userProfileUrl'] = comment.userProfileUrl;
    }

    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);
    final newReply = ReplyModel(
            userProfileUrl: reply.userProfileUrl,
            username: reply.username,
            replyId: reply.replyId,
            commentId: reply.commentId,
            postId: reply.postId,
            likes: const [],
            description: reply.description,
            creatorUid: reply.creatorUid,
            createAt: reply.createAt)
        .toJson();
    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReply).then((value) {
          final commentCollection = firebaseFirestore
              .collection(FirebaseConstants.Comment)
              .doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalreplies = value.get('totalReplies');
              commentCollection.update({"totalReplies": totalreplies + 1});
              return;
            }
          });
        });
      } else {
        replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    try {
      replyCollection.doc(reply.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConstants.Comment)
            .doc(reply.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplies = value.get('totalReplies');
            commentCollection.update({"totalReplies": totalReplies - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);
    final currentUid = await getCurrentUid();
    final replyRef = await replyCollection.doc(reply.replyId).get();
    if (replyRef.exists) {
      List likes = replyRef.get("likes");
      if (likes.contains(currentUid)) {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply) {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection =
        firebaseFirestore.collection(FirebaseConstants.Reply);

    Map<String, dynamic> replyInfo = {};
    if (reply.description != "" && reply.description != null) {
      replyInfo['description'] = reply.description;
    }

    if (reply.userProfileUrl != "" && reply.userProfileUrl != null) {
      replyInfo['userProfileUrl'] = reply.userProfileUrl;
    }

    replyCollection.doc(reply.replyId).update(replyInfo);
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
