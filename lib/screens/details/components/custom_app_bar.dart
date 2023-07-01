import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/screens/Review/Feedbackpage.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../size_config.dart';
import '../../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Product product;

  CustomAppBar({ required this.product});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void handleRatingTap(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, SignInScreen.routeName);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackPage(
            userId: user.uid,
            productId: product.id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  primary: kPrimaryColor,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => handleRatingTap(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [

                    const SizedBox(width: 5),
                    SvgPicture.asset("assets/icons/Star Icon.svg"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
