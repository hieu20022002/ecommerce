import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets.dart';
import 'components/Body.dart';


class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomNavBar(selectedMenu: MenuState.home),
    );
  }
}