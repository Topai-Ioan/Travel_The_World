import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/UI/main_screen/main_screen.dart';
import 'package:travel_the_world/UI/credential/widgets/form_container_widget.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isSigningIn = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isSigningIn.dispose();
    super.dispose();
  }

  void _signInUser() {
    _isSigningIn.value = true;
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _passwordController.clear();
      _isSigningIn.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            context.read<AuthCubit>().loggedIn();
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
                  return BodyWidget(_emailController, _passwordController,
                      _isSigningIn, _signInUser);
                }
              },
            );
          }

          return BodyWidget(
              _emailController, _passwordController, _isSigningIn, _signInUser);
        },
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final ValueNotifier<bool> _isSigningIn;
  final VoidCallback _signInUser;

  const BodyWidget(this._emailController, this._passwordController,
      this._isSigningIn, this._signInUser,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
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
            textStyle: Fonts.f18w600(
              color: getTextColor(context),
            ),
            backgroundColor:
                getThemeColor(context, AppColors.white, AppColors.black),
            text: "Sign In",
            onTapListener: _signInUser,
          ),
          sizeVertical(10),
          ValueListenableBuilder<bool>(
            valueListenable: _isSigningIn,
            builder: (context, isSigningIn, child) {
              if (isSigningIn) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Please wait",
                          style: Fonts.f16w400(color: AppColors.black)),
                      sizeHorizontal(10),
                      const CircularProgressIndicator()
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Flexible(flex: 2, child: Container()),
          const Divider(
            thickness: 3,
            color: AppColors.darkOlive,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: Fonts.f16w400(color: getTextColor(context)),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.SignUpPage, (route) => false);
                },
                child: Text(
                  "Sign Up.",
                  style: Fonts.f18w600(color: getTextColor(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
