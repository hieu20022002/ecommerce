import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/models/User.dart';
import 'package:ecommerce/screens/Order_Management/OrderScreensMana.dart';
import 'package:ecommerce/screens/Product_Management/addproductscreen.dart';
import 'package:ecommerce/screens/Statistic/statistic_screen.dart';
import 'package:ecommerce/screens/cart/cart_screen.dart';
import 'package:ecommerce/screens/details/details_screen.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/screens/my_account/my_account.dart';
import 'package:ecommerce/screens/otp/otp_screen.dart';
import 'package:ecommerce/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../screens/check_out/CheckoutScreen.dart';
import '../screens/complete_profile/complete_profile_screen.dart';
import '../screens/forgot_password/forgot_password_screen.dart';
import '../screens/login_success/login_success_screen.dart';
import '../screens/sign_in/sign_in_screen.dart';
import 'package:ecommerce/screens/profile/profile_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (content) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  MyAccountScreen.routeName: (context) => MyAccountScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  AddProductScreen.routeName: (context) => AddProductScreen(),
  OrderScreensMana.routeName: (context) => OrderScreensMana(),
  StatisticScreen.routeName: (context) => StatisticScreen(),
};
