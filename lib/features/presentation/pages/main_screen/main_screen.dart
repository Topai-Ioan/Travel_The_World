import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/pages/activity/activity_page.dart';
import 'package:travel_the_world/features/presentation/pages/profile/profile_page.dart';
import 'package:travel_the_world/features/presentation/pages/search/search_page.dart';
import 'package:travel_the_world/features/presentation/pages/upload_post/upload_post_page.dart';

import '../home/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
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
    return Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: backgroundColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                color: primaryColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_rounded,
                color: primaryColor,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_rounded,
                color: primaryColor,
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_rounded,
                color: primaryColor,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: primaryColor,
              ),
              label: 'Profile',
            ),
          ],
          onTap: navigationTapped,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: const [
            HomePage(),
            SearchPage(),
            UploadPostPage(),
            ActivityPage(),
            ProfilePage()
          ],
        ));
  }
}
