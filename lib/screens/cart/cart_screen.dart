import 'package:ecommerce/screens/cart/componets/body.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/Cart.dart';
import 'componets/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return SignInScreen();
    } else
      return Scaffold(
        appBar: buildAppBar(context),
        body: Body(),
        bottomNavigationBar: CheckoutCard(),
      );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "items",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
