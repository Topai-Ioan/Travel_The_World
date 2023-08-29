import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("${currentUser.username}",
            style: const TextStyle(color: primaryColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                _openBottomModalSheet(context);
              },
              child: const Icon(Icons.menu, color: primaryColor),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: profileWidget(imageUrl: currentUser.profileUrl),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${currentUser.totalPosts}',
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          sizeVertical(7),
                          const Text('Posts',
                              style: TextStyle(color: primaryColor))
                        ],
                      ),
                      sizeHorizontal(25),
                      Column(
                        children: [
                          Text('${currentUser.totalFollowers}',
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          sizeVertical(7),
                          const Text(
                            'Followers',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                      sizeHorizontal(25),
                      Column(
                        children: [
                          Text('${currentUser.totalFollowing}',
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          sizeVertical(7),
                          const Text(
                            'Following',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              sizeVertical(10),
              Text(
                '${currentUser.name == '' ? currentUser.username : currentUser.name}',
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeVertical(10),
              Text(
                '${currentUser.bio}',
                style: const TextStyle(color: primaryColor),
              ),
              sizeVertical(10),
              GridView.builder(
                itemCount: 32,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return _ModalContent(user: currentUser);
      },
    );
  }
}

class _ModalContent extends StatelessWidget {
  final UserEntity user;

  const _ModalContent({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.transparent.withOpacity(0.5),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OptionItem(
                text: "Settings",
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              _OptionItem(
                text: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.EditProfilePage,
                      arguments: user);
                },
              ),
              const SizedBox(height: 7),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 7),
              _OptionItem(
                text: "Logout",
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.SignInPage, (route) => false);
                },
              ),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
