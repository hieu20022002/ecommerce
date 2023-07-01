import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce/components/default_button.dart';
import 'package:intl/intl.dart';
import '../../../models/Voucher.dart';
import '../../../size_config.dart';
import '../../check_out/CheckoutScreen.dart';
import '../../constants.dart';
import '../../voucher/Apply_Voucher.dart';

class CheckoutCard extends StatefulWidget {
  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  final CartController cartController = CartController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Voucher? _selectedShippingVoucher;
  Voucher? _selectedDiscountVoucher;

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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoucherScreen(
                      onVoucherSelected: (voucher) {
                        setState(() {
                          if (voucher?.type == 'Discount') {
                            _selectedDiscountVoucher = voucher;
                          } else if (voucher?.type == 'FreeShipping') {
                            _selectedShippingVoucher = voucher;
                          }
                        });
                      },
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: getProportionateScreenWidth(40),
                    width: getProportionateScreenWidth(40),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset("assets/icons/receipt.svg"),
                  ),
                  Spacer(),
                  if (_selectedDiscountVoucher != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedDiscountVoucher!.type,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: kTextColor,
                          ),
                        ],
                      ),
                    ),
                  if (_selectedShippingVoucher != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedShippingVoucher!.type,
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: kTextColor,
                          ),
                        ],
                      ),
                    ),
                  if (_selectedDiscountVoucher == null &&
                      _selectedShippingVoucher == null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Add voucher code",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: kTextColor,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: NumberFormat('#,###', 'vi_VN')
                                .format(cartController.cart.total) +
                            "\₫",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            cartController: cartController,
                            selectedShippingVoucher: _selectedShippingVoucher,
                            selectedDiscountVoucher: _selectedDiscountVoucher,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
