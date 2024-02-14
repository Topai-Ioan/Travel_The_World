import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/firestore/users/user_service.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/store_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  Future<void> signInUser(UserModel user) async {
    try {
      if (user.email.isNotEmpty || user.password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email.replaceAll(" ", ""), password: user.password);
      } else {
        toast("fields cannot be empty");
      }
    } on FirebaseAuthException catch (_) {
      //todo log exceptions

      toast("Invalid credentials");
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> signUpUser(UserModel user) async {
    final passwordPattern = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>])[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{8,}$');

    if (!passwordPattern.hasMatch(user.password)) {
      toast(
          "Password must contain at least one uppercase letter, one lowercase letter, one number, one special character, and be at least 8 characters long.");
      return;
    }

    if (!user.password
        .contains(RegExp(r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>]+$'))) {
      toast("Only English characters allowed");
      return;
    }

    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email.replaceAll(" ", ""), password: user.password)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          String profileUrl = '';
          if (user.imageFile != null) {
            profileUrl = await StoreService()
                .uploadImageProfilePicture(user.imageFile!, "ProfileImages");
          }
          UserService().createUser(user: user, profileUrl: profileUrl);
        }
      });
      return;
    } on FirebaseAuthException catch (_) {
      toast("Something went wrong");
    }
  }
}
