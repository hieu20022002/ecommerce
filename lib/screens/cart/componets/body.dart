import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CartController cartController = CartController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCart();
  }

  void _getCart() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await cartController.fetchCart(user.uid);
            setState(() {});
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: cartController.cart.cartDetails.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(cartController.cart.cartDetails[index].productId),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await cartController.deleteProductByIdandUserID(
                  cartController.cart.cartDetails[index].productId,
                  cartController.cart.userId);
              setState(() {
                cartController.cart.cartDetails.removeAt(index);
              });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(cartdetail: cartController.cart.cartDetails[index]),
          ),
        ),
      ),
    );
  }
}