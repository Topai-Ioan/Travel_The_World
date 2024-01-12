import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/firestore/comments/comment_service.dart';
import 'package:travel_the_world/services/firestore/comments/comment_service_interface.dart';
import 'package:travel_the_world/services/firestore/posts/post_service.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/firestore/replies/reply_service.dart';
import 'package:travel_the_world/services/firestore/replies/reply_service_interface.dart';
import 'package:travel_the_world/services/firestore/users/user_service.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton<UserServiceInterface>(() => UserService());
  sl.registerLazySingleton<ReplyServiceInterface>(() => ReplyService());
  sl.registerLazySingleton<PostServiceInterface>(() => PostService());
  sl.registerLazySingleton<CommentServiceInterface>(() => CommentService());

  sl.registerFactory<UserCubit>(
      () => UserCubit(userService: sl<UserServiceInterface>()));
  sl.registerFactory<GetSingleUserCubit>(
      () => GetSingleUserCubit(userService: sl<UserServiceInterface>()));
  sl.registerFactory<GetSingleOtherUserCubit>(
      () => GetSingleOtherUserCubit(userService: sl<UserServiceInterface>()));
  sl.registerFactory(() => PostCubit(postService: sl<PostServiceInterface>()));
  sl.registerFactory(
      () => GetSinglePostCubit(postService: sl<PostServiceInterface>()));
  sl.registerFactory(() => CommentCubit(commentService: CommentService()));
  sl.registerFactory(
      () => ReplyCubit(replyService: sl<ReplyServiceInterface>()));

  //todo
  sl.registerFactory(() => AuthCubit(authService: AuthService()));
  sl.registerFactory(() => CredentialCubit());

  // Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
