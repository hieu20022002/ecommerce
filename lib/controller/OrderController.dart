import 'package:ecommerce/models/Order.dart';
import 'package:flutter/material.dart';

class OrderController extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  void order(List<Order> orders) {
    for (var i = 0; i < orders.length; i++) {
      _orders.add(orders[i]);
    }
    notifyListeners();
  }

  Future<void> fetchOrder() async {
    try {
      List<Order> orders = await Order.getOrders();
      order(orders);
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> updateOrderStatus(String orderId, int newStatus) async {
    try {
      await Order.updateStatusById(orderId, newStatus);
            // Cập nhật trạng thái trong danh sách _orders
    } catch (error) {
      print('Error updating order status: $error');
      // Xử lý lỗi theo yêu cầu của bạn
    }
  }
}
