import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/widgets/credential/form_container_widget.dart';
import 'package:travel_the_world/features/presentation/widgets/credential/button_container_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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
              text: "Sign In",
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
                  "Don't have and account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageRoutes.SignUpPage, (route) => false);
                  },
                  child: const Text(
                    "Sign Up.",
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
