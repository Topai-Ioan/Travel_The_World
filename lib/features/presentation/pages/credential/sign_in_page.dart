import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/main_screen/main_screen.dart';
import 'package:travel_the_world/features/presentation/pages/credential/widgets/form_container_widget.dart';
import 'package:travel_the_world/features/presentation/pages/credential/widgets/button_container_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  //todo duplicate code as in sign_up_page.dart, make something to hold this code and give _bodyWidget as a parameter
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if (credentialState is CredentialFailure) {
              toast("Invalid credentials");
            }
          },
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return _bodyWidget();
                }
              });
            }

            return _bodyWidget();
          },
        ));
  }

  _bodyWidget() {
    return Padding(
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
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
          ),
          sizeVertical(15),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVertical(15),
          ButtonContainerWidget(
            color: blueColor,
            text: "Sign In",
            onTapListener: () {
              _signInUser();
            },
          ),
          sizeVertical(10),
          if (_isSigningIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Please wait",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                sizeHorizontal(10),
                const CircularProgressIndicator()
              ],
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
    );
  }

  void _signInUser() {
    _isSigningIn = true;
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
            email: _emailController.text, password: _passwordController.text)
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isSigningIn = false;
    });
  }
}
