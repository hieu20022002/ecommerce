import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/screens/constants.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/cart/cart_screen.dart';
import '../screens/home/components/icon_btn_with_counter.dart';
import '../screens/home/components/search_field.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String Title;
  const CustomAppBar({
    Key? key,
    required this.Title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cartItemCount = 0;



    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField( // Truyền productController vào SearchField
),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            press: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);
}