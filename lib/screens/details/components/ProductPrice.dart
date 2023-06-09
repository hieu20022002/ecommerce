import 'package:ecommerce/components/rounded_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';
import '../../constants.dart';

import 'package:flutter/foundation.dart';

class QuantityCounter extends StatefulWidget {
  final ValueNotifier<int> quantity;

  const QuantityCounter({
    Key? key,
    required this.quantity,
  }) : super(key: key);

  @override
  _QuantityCounterState createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (widget.quantity.value > 1) {
                widget.quantity.value--;
              }
            },
            icon: Icon(Icons.remove),
          ),
          SizedBox(
            width: getProportionateScreenWidth(20),
            child: ValueListenableBuilder<int>(
              valueListenable: widget.quantity,
              builder: (context, value, _) {
                return Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              widget.quantity.value++;
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
    required this.quantity,
  }) : super(key: key);

  final Product product;
  final ValueNotifier<int> quantity;

  @override
  Widget build(BuildContext context) {
    int totalPrice = product.price * quantity.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat('#,###', 'vi_VN').format(totalPrice) + "\₫",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          QuantityCounter(quantity: quantity),
        ],
      ),
    );
  }
}
