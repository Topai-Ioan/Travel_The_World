import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/credential/sign_in_page.dart';
import 'package:travel_the_world/UI/main_screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_the_world/themes/theme_provider.dart';
import 'package:travel_the_world/themes/themes.dart';
import 'on_generate_route.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await initializeApp();

  final themeProvider = ThemeProvider(Themes.systemTheme);
  await themeProvider.loadThemeFromPrefs();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
        BlocProvider(create: (_) => di.sl<PostCubit>()),
        BlocProvider(create: (_) => di.sl<GetSinglePostCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData,
        title: 'Travel the world',
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return MainScreen(uid: authState.uid);
            } else {
              return const SignInPage();
            }
          },
        ),
      ),
    );
  }
}
