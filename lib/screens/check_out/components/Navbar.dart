import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/screens/MyOrder_Management/my_order_management.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Navbar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckoutPressed;

  const Navbar({
    required this.totalPrice,
    required this.onCheckoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat('#,###', 'vi_VN').format(totalPrice) + "\₫",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onCheckoutPressed();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderManagementScreen(initialIndex: 0)),
              );
            },
            child: Text("Checkout"),
          ),
        ],
      ),
    );
  }
}
