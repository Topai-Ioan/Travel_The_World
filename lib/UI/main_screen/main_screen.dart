import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/UI/activity/activity_page.dart';
import 'package:travel_the_world/UI/profile/profile_page.dart';
import 'package:travel_the_world/UI/search/search_page.dart';
import 'package:travel_the_world/UI/post/post/upload/upload_post_page.dart';
import 'package:travel_the_world/themes/app_colors.dart';

import '../home/home_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({super.key, required this.uid});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getsingleUserState) {
        if (getsingleUserState is GetSingleUserLoaded) {
          final currentUser = getsingleUserState.user;
          return Scaffold(
            bottomNavigationBar: CustomCupertinoTabBar(
              currentIndex: _currentIndex,
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                HomePage(currentUser: currentUser),
                const SearchPage(),
                UploadPostPage(currentUser: currentUser),
                const ActivityPage(),
                ProfilePage(currentUser: currentUser)
              ],
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class CustomCupertinoTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomCupertinoTabBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      backgroundColor: AppColors.darkOlive,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_rounded),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      activeColor: AppColors.olive,
      inactiveColor: AppColors.white,
    );
  }
}
