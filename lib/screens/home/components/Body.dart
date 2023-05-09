import 'package:ecommerce/components/custom_appbar.dart';
import 'package:ecommerce/screens/home/components/brands.dart';
import 'package:ecommerce/screens/home/components/categories.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';

import 'discount_banner.dart';
import 'popular_products.dart';
import 'topnew_products.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            CustomAppBar(Title: 'Trang chủ'),
            SizedBox(height: getProportionateScreenWidth(10)),
            DiscountBanner(),
            Categories(),
            Brands(),
            SizedBox(height: getProportionateScreenWidth(30)),
            PopularProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
            TopNewProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}