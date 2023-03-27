import 'package:ecommerce/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/enums.dart';

import '../../components/custom_navbar.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar: CustomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
