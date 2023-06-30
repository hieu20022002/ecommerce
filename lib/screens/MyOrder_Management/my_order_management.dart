import 'package:ecommerce/controller/OrderController.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/screens/MyOrder_Management/my_order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderManagementScreen extends StatefulWidget {
  final int initialIndex;
  const OrderManagementScreen({Key? key, this.initialIndex = 0})
      : super(key: key);
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with TickerProviderStateMixin {
  final OrderController orderController = OrderController();
  final User? user = FirebaseAuth.instance.currentUser;
  List<Order> toPayOrders = [];
  List<Order> toShipOrders = [];
  List<Order> toReceiveOrders = [];
  List<Order> completedOrders = [];
  List<Order> cancelledOrders = [];
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchOrders(user!.uid);
    }
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  Future<void> fetchOrders(String uid) async {
    try {
      List<Order> orders = await Order.getOrdersByUserId(uid);
      setState(() {
        toPayOrders = orders.where((order) => order.status == 0).toList();
        toShipOrders = orders.where((order) => order.status == 1).toList();
        toReceiveOrders = orders.where((order) => order.status == 2).toList();
        completedOrders = orders
            .where((order) => order.status == 3 || order.status == 4)
            .toList();
        cancelledOrders = orders.where((order) => order.status == 5).toList();
      });
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> updateOrderStatusAndFetch(String orderId, int newStatus) async {
    try {
      await orderController.updateOrderStatus(orderId, newStatus);
      orderController.fetchOrder();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrderManagementScreen(initialIndex: newStatus)),
      ); // Tải lại danh sách đơn hàng mới
    } catch (error) {
      print('Error updating order status: $error');
      // Xử lý lỗi theo yêu cầu của bạn
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Management',
            style: TextStyle(color: Colors.deepOrange),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'To Pay'),
              Tab(text: 'To Ship'),
              Tab(text: 'To Receive'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Thêm nội dung cho từng tab tại đây
            buildOrderList(toPayOrders),
            buildOrderList(toShipOrders),
            buildOrderList(toReceiveOrders),
            buildOrderList(completedOrders),
            buildOrderList(cancelledOrders),
          ],
        ),
      ),
    );
  }

  Widget buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        Order order = orders[index];
        return MyOrderCard(
          order: order,
          updateOrderStatusAndFetch: (orderId, status) {
            // Implement the logic to update order status and fetch updated orders
            updateOrderStatusAndFetch(orderId, status);
          },
        );
      },
    );
  }
}
