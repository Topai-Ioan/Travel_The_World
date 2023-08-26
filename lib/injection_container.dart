import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/data/repository/firebase_repository.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/create_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_single_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_users_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/is_sign_in_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_in_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_out_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_up_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/update_user_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance; //service locator

Future<void> init() async {
  // cubits
  sl.registerFactory(() => AuthCubit(
        getCurrentUidUseCase: sl.call(),
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
      ));
  sl.registerFactory(() => CredentialCubit(
        signUpUseCase: sl.call(),
        signInUserUseCase: sl.call(),
      ));
  sl.registerFactory(() => UserCubit(
        updateUserUseCase: sl.call(),
        getUsersUseCase: sl.call(),
      ));

  sl.registerFactory(() => GetSingleUserCubit(
        getSingleUserUseCase: sl.call(),
      ));

  // usecases
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(() => UploadImageUseCase(repository: sl.call()));

  // repositories
  sl.registerLazySingleton<FirebaseRepositoryInterface>(
      () => FirebaseRepository(remoteDataSource: sl.call()));

  // remote data source
  sl.registerLazySingleton<FirebaseRemoteDataSourceInterface>(() =>
      FirebaseRemoteDataSource(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  // externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
