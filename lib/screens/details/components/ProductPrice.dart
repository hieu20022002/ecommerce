import 'package:ecommerce/components/rounded_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';
import '../../constants.dart';

class QuantityCounter extends StatefulWidget {
  const QuantityCounter({
    Key? key,
  }) : super(key: key);

  @override
  _QuantityCounterState createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  int numOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (numOfItems > 1) {
                  numOfItems--;
                }
              });
            },
            icon: Icon(Icons.remove),
          ),
          SizedBox(
            width: getProportionateScreenWidth(20),
            child: Text(
              numOfItems.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                numOfItems++;
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat('#,###', 'vi_VN').format(product.price) + "\₫",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          QuantityCounter(),
        ],
      ),
    );
  }
}
