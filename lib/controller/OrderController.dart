import 'package:ecommerce/models/Order.dart';
import 'package:flutter/material.dart';

class OrderController extends ChangeNotifier{
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  void order(List<Order> orders){
    for(var i = 0; i < orders.length; i++){
      _orders.add(orders[i]);
    }
    notifyListeners();
  }
  Future<void> fetchOrder() async{
    try{
      List<Order> orders = await Order.getOrders();
      order(orders);
    }catch(error){
      print('Error fetching orders: $error');
    }
  }

  void updateOrder(Order order, String s, bool bool) {}
}