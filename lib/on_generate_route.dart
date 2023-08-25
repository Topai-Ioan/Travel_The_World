import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/pages/credential/sign_in_page.dart';
import 'package:travel_the_world/features/presentation/pages/credential/sign_up_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/comment_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/edit_post_page.dart';
import 'package:travel_the_world/features/presentation/pages/profile/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageRoutes.EditProfilePage:
        return routeBuilder(const EditProfilePage());

      case PageRoutes.EditPostPage:
        return routeBuilder(const EditPostPage());

      case PageRoutes.CommentPage:
        return routeBuilder(const CommentPage());

      case PageRoutes.SignInPage:
        return routeBuilder(const SignInPage());

      case PageRoutes.SignUpPage:
        return routeBuilder(const SignUpPage());

      default:
        return routeBuilder(const NoPageFound());
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No page found"),
      ),
      body: const Center(child: Text("No page found")),
    );
  }
}
