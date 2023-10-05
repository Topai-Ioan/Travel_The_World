import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/repository/firebase_repository.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/comment/create_comment_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/comment/delete_comment_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/comment/like_comment_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/comment/read_comments_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/comment/update_comment_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/create_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/delete_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/like_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/read_posts_from_following_users_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/read_posts_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/read_single_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/update_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/sync_profile_picture.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/create_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/delete_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/like_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/read_replies_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/update_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image_post.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image_profile_picture.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/is_sign_in_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_in_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_out_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_up_user_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => CredentialCubit(
      signUpUseCase: sl.call(),
      signInUserUseCase: sl.call(),
    ),
  );
  sl.registerFactory<UserCubit>(() => UserCubit());
  sl.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit());
  sl.registerFactory<GetSingleOtherUserCubit>(() => GetSingleOtherUserCubit());

  // Post Cubit Injection
  sl.registerFactory(() => PostCubit(
        updatePostUseCase: sl.call(),
        deletePostUseCase: sl.call(),
        likePostUseCase: sl.call(),
        createPostUseCase: sl.call(),
        readPostUseCase: sl.call(),
        readPostsFromFollowingUsersUseCase: sl.call(),
      ));

  sl.registerFactory(
    () => GetSinglePostCubit(readSinglePostUseCase: sl.call()),
  );

  // Comment Cubit Injection
  sl.registerFactory(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
    ),
  );

  // Reply Cubit Injection
  sl.registerFactory(
    () => ReplyCubit(
        createReplyUseCase: sl.call(),
        deleteReplyUseCase: sl.call(),
        likeReplyUseCase: sl.call(),
        readRepliesUseCase: sl.call(),
        updateReplyUseCase: sl.call()),
  );

  // Use Cases
  // User
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageProfilePictureUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UploadImagePostUseCase(repository: sl.call()));

  // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => ReadPostsFromFollowingUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => SyncProfilePictureUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Reply
  sl.registerLazySingleton(() => CreateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadRepliesUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<FirebaseRepositoryInterface>(
      () => FirebaseRepository(remoteDataSource: sl.call()));
  // Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSourceInterface>(() =>
      FirebaseRemoteDataSource(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  // Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
