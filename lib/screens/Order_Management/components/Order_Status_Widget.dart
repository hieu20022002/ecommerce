import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final int orderStatus;
  const OrderStatusWidget({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String statusText;
    final Color statusBackgroundColor;
    switch (orderStatus) {
      case 0:
        statusText = 'Chờ xác nhận';
        statusBackgroundColor = Color(0xFFF79C39);
        break;
      case 1:
        statusText = 'Đã xác nhận đơn hàng';
        statusBackgroundColor = Color(0xFF4BCBF9);
        break;
      case 2:
        statusText = 'Đang giao hàng';
        statusBackgroundColor = Color(0xFF7A63EC);
        break;
      case 3:
        statusText = 'Đã thanh toán';
        statusBackgroundColor = Color(0xFF48E98A);
        break;
      case 4:
        statusText = 'Chờ xác nhận hủy';
        statusBackgroundColor = Color.fromARGB(255, 205, 75, 162);
        break;
      case 5:
        statusText = 'Đã hủy';
        statusBackgroundColor = Color(0xFFFE4651);
        break;
      default:
        statusText = 'Không xác định';
        statusBackgroundColor = Color.fromARGB(255, 5, 0, 13);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: statusBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Text(
        statusText,
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}