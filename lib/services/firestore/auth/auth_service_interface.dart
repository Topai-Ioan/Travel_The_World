import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

abstract class AuthServiceInterface {
  User? getCurrentUser();

  String? getCurrentUserId();

  Future<bool> isSignIn();

  Future<void> signInUser({required UserModel user});

  Future<void> signOut();

  Future<void> signUpUser({required UserModel user});
}
