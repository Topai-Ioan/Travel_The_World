import 'package:flutter/material.dart';
import 'package:travel_the_world/features/presentation/pages/main_screen/main_screen.dart';
import 'features/presentation/pages/credential/sign_in_page.dart';
import 'features/presentation/pages/credential/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel the world',
      darkTheme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}
