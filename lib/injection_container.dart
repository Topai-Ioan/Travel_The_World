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
import 'package:travel_the_world/services/firestore/comments/comment_service.dart';
import 'package:travel_the_world/services/firestore/users/user_service.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(),
  );
  sl.registerFactory(
    () => CredentialCubit(),
  );

  sl.registerLazySingleton<UserServiceInterface>(() => UserService());
  sl.registerFactory<UserCubit>(
      () => UserCubit(userService: sl<UserServiceInterface>()));

  sl.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit());
  sl.registerFactory<GetSingleOtherUserCubit>(() => GetSingleOtherUserCubit());

  // Post Cubit Injection
  sl.registerFactory(() => PostCubit());

  sl.registerFactory(
    () => GetSinglePostCubit(),
  );

  //sl.registerLazySingleton<CommentServiceInterface>(() => UserService());

  // Comment Cubit Injection
  sl.registerFactory(
    () => CommentCubit(commentService: CommentService()),
  );

  // Reply Cubit Injection
  sl.registerFactory(
    () => ReplyCubit(),
  );

  // Use Cases
  // User

  // Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
