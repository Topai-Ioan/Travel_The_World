import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/app_entity.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/presentation/pages/credential/sign_in_page.dart';
import 'package:travel_the_world/features/presentation/pages/credential/sign_up_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/comment_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/edit_reply_page.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/like_list_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/post_detail_page.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/update_post_page.dart';
import 'package:travel_the_world/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/followers_page.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/following_page.dart';
import 'package:travel_the_world/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageRoutes.EditProfilePage:
        if (args is UserModel) {
          return routeBuilder(EditProfilePage(currentUser: args));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageRoutes.UpdatePostPage:
        {
          if (args is PostModel) {
            return routeBuilder(UpdatePostPage(post: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageRoutes.UpdateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(EditCommentPage(
              comment: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageRoutes.CommentPage:
        {
          if (args is AppEntity) {
            return routeBuilder(CommentPage(
              appEntity: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageRoutes.UpdateReplyPage:
        {
          if (args is ReplyEntity) {
            return routeBuilder(EditReplyPage(
              reply: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageRoutes.PostDetailPage:
        {
          if (args is String) {
            return routeBuilder(PostDetailPage(
              postId: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageRoutes.SingleUserProfilePage:
        {
          if (args is String) {
            return routeBuilder(SingleUserProfilePage(
              otherUserId: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageRoutes.FollowingPage:
        {
          if (args is UserModel) {
            return routeBuilder(FollowingPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageRoutes.FollowersPage:
        {
          if (args is UserModel) {
            return routeBuilder(FollowersPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageRoutes.LikeListPage:
        {
          if (args is PostModel) {
            return routeBuilder(LikeListPage(
              post: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
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
