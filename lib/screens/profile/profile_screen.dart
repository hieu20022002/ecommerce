import 'package:ecommerce/components/custom_appbar.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/enums.dart';
import '../../components/custom_navbar.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null){
      return SignInScreen();
    }
    else{
          return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar: CustomNavBar(selectedMenu: MenuState.profile),
    );
    }

  }
}
