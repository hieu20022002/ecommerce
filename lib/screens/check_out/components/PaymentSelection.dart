import 'package:ecommerce/screens/check_out/components/PaymentMethodTile.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              PaymentMethodTile(
                icon: Icons.credit_card,
                label: "Credit Card",
              ),
              SizedBox(width: 10),
              PaymentMethodTile(
                icon: Icons.payment,
                label: "PayPal",
              ),
              SizedBox(width: 10),
              PaymentMethodTile(
                icon: Icons.monetization_on,
                label: "Cash on Delivery",
              ),
            ],
          ),
        ],
      ),
    );
  }
}