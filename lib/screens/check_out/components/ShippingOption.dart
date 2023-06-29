import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShippingOption extends StatelessWidget {
  final String option;
  final String estimatedDeliveryTime;
  final double shippingFee;

  const ShippingOption({
    required this.option,
    required this.estimatedDeliveryTime,
    required this.shippingFee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping Option",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            option,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Receive by $estimatedDeliveryTime",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                NumberFormat('#,###', 'vi_VN')
                                .format(shippingFee) +
                            "\₫",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}