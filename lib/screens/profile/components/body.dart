import 'package:ecommerce/screens/Order_Management/OrderScreensMana.dart';
import 'package:ecommerce/screens/Product_Management/addproductscreen.dart';
import 'package:ecommerce/screens/Statistic/statistic_screen.dart';
import 'package:ecommerce/screens/my_account/my_account.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_order.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          MyOrder(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                {Navigator.pushNamed(context, MyAccountScreen.routeName)},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () =>
                {Navigator.pushNamed(context, AddProductScreen.routeName)},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () =>
                {Navigator.pushNamed(context, OrderScreensMana.routeName)},
          ),
          ProfileMenu(
            text: "Statistic",
            icon: "assets/icons/Discover.svg",
            press: () =>
                {Navigator.pushNamed(context, StatisticScreen.routeName)},
          ),
          ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async => {
                    await FirebaseAuth.instance.signOut(),
                    Navigator.pushNamed(context, SignInScreen.routeName),
                  }),
        ],
      ),
    );
  }
}
