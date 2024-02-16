import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/UI/home/widgets/post_options_modal.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;
  final String currentUserId;

  const PostHeader({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRoutes.SingleUserProfilePage,
                arguments: post.creatorUid,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: profileWidget(
                      imageUrl: post.userProfileUrl,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                sizeHorizontal(10),
                Text(
                  post.username,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizeHorizontal(5),
              ],
            ),
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(post.createdAt!),
            style: TextStyle(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          if (post.creatorUid == currentUserId) ...[
            GestureDetector(
              onTap: () {
                PostOptionsModal(
                  post: post,
                ).showOptions(context);
              },
              child: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).primaryColor,
              ),
            )
          ]
        ],
      ),
    );
  }
}
