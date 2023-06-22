import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../MyOrder_Management/my_order_management.dart';

class MyOrder extends StatelessWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: const Text(
                'My Purchases',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Điều hướng đến trang quản lý đơn hàng cá nhân
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderManagementScreen()),
                );
              },
              child: Row(
                children: const [
                  Text('View Purchase history'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.withOpacity(0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                OrderStatus(
                  text: 'To Pay',
                  icon: Icons.payment,
                  tabIndex: 0,
                ),
                VerticalDivider(),
                OrderStatus(
                  text: 'To Ship',
                  icon: Icons.local_shipping,
                  tabIndex: 1,
                ),
                VerticalDivider(),
                OrderStatus(
                  text: 'To Receive',
                  icon: Icons.receipt_long,
                  tabIndex: 2,
                ),
                VerticalDivider(),
                OrderStatus(
                  text: 'Completed',
                  icon: Icons.check_circle_outline,
                  tabIndex: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String text;
  final IconData icon;
  final int tabIndex;
  const OrderStatus({
    Key? key,
    required this.text,
    required this.icon,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderManagementScreen(initialIndex: tabIndex)),
          );
        },
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
