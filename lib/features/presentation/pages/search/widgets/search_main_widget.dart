import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/search/widgets/search_widget.dart';
import 'package:travel_the_world/profile_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(controller: _searchController),
                sizeVertical(10),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoaded) {
                      final posts = postState.posts;
                      return GridView.builder(
                        itemCount: posts.length,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageRoutes.PostDetailPage,
                                  arguments: posts[index].postId);
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: profileWidget(
                                  imageUrl: posts[index].postImageUrl),
                            ),
                          );
                        },
                      );
                    }
                    return const Text(
                      'No data found!',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
