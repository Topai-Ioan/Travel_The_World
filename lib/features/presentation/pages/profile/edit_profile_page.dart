import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_form_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Edit Profile',
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.close,
            size: 32,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.done,
                size: 32,
                color: blueColor,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
            sizeVertical(15),
            const Text(
              "Change profile photo",
              style: TextStyle(
                  color: blueColor, fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const ProfileFormWidget(title: "Name"),
            const ProfileFormWidget(title: "Username"),
            const ProfileFormWidget(title: "Website"),
            const ProfileFormWidget(title: "Bio"),
          ]),
        ),
      ),
    );
  }
}
