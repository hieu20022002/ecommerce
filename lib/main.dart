import 'package:ecommerce/screens/screens.dart';
import 'package:flutter/material.dart';

import 'config/routers.dart';
import 'theme.dart';

import 'package:ecommerce/screens/profile/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecomerce App',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name

      initialRoute:SignInScreen.routeName,
      routes: routes,
    );
  }
}
