import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/repository/firebase_repository.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/sync_profile_picture.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/create_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/delete_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/like_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/read_replies_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/update_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image_post.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';
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
    () => ReplyCubit(
        createReplyUseCase: sl.call(),
        deleteReplyUseCase: sl.call(),
        likeReplyUseCase: sl.call(),
        readRepliesUseCase: sl.call(),
        updateReplyUseCase: sl.call()),
  );

  // Use Cases
  // User

  // Cloud Storage
  sl.registerLazySingleton(() => UploadImagePostUseCase(repository: sl.call()));

  // Post
  sl.registerLazySingleton(
      () => SyncProfilePictureUseCase(repository: sl.call()));

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
