import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/pages/credential/sign_in_page.dart';
import 'package:travel_the_world/features/presentation/widgets/form_container_widget.dart';
import 'package:travel_the_world/features/presentation/widgets/button_container_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            Center(
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.green, BlendMode.srcIn),
              ),
            ),
            sizeVertical(30),
            Center(
              child: Stack(
                children: [
                  SizedBox.fromSize(
                    size: const Size(75, 75),
                    child: Image.asset("assets/images/profile_default.png"),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: blueColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizeVertical(30),
            const FormContainerWidget(
              hintText: "Username",
            ),
            sizeVertical(15),
            const FormContainerWidget(
              hintText: "Email",
            ),
            sizeVertical(15),
            const FormContainerWidget(
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVertical(15),
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign Up",
              onTapListener: () {},
            ),
            Flexible(flex: 2, child: Container()),
            const Divider(
              color: greenColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have and account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                        (route) => false);
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
