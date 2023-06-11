import 'package:ecommerce/controller/OrderController.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/models/OrderDetail.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/screens/Order_Management/components/Order_Status_Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderScreensMana extends StatefulWidget {
  static String routeName = "/order_screens_mana";
  const OrderScreensMana({Key? key}) : super(key: key);
  
  @override
  _OrderScreensManaState createState() => _OrderScreensManaState();
}

class _OrderScreensManaState extends State<OrderScreensMana> {
  OrderController orderController =
      OrderController(); // Tạo một đối tượng OrderController
  bool isFetching = false;
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  Future<void> updateOrderStatusAndFetch(String orderId, int newStatus) async {
    try {
      await orderController.updateOrderStatus(orderId, newStatus);
      if (!isFetching) {
        orderController.fetchOrder();
        setState(() {}); // Tải lại danh sách đơn hàng mới
      }
    } catch (error) {
      print('Error updating order status: $error');
      // Xử lý lỗi theo yêu cầu của bạn
    }
  }
  Future<void> fetchOrders() async {
    try {
      isFetching = true; // Đặt biến cờ thành true trước khi bắt đầu tải dữ liệu
      List<Order> orders = await Order.getOrders();
      orderController.order(orders);
      setState(() {});
    } catch (error) {
      print('Error fetching orders: $error');
    } finally {
      isFetching = false; // Đặt biến cờ thành false sau khi tải dữ liệu hoàn thành
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Management"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orderController.orders.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderCard(
                    order: orderController.orders[index],
                    updateOrderStatusAndFetch: updateOrderStatusAndFetch);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  OrderCard({
    Key? key,
    required this.order,
    required this.updateOrderStatusAndFetch
  }) : super(key: key);

  final Order order;
  final Function(String, int) updateOrderStatusAndFetch;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: OrderStatusWidget(orderStatus: order.status),
            ),
            FutureBuilder<Address>(
              future: Order.getByAddressId(order.addressId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Address address = snapshot.data!;
                  return ListTile(
                    title: Text('Người nhận: ${address.receiver}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Số điện thoại: ${address.phoneNumber}'),
                        Text('Địa chỉ: ${address.addressLine}'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Lỗi khi tải thông tin địa chỉ');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            ListTile(
              title: Text('Ngày tạo: ${order.createdAt.toString()}'),
            ),
            // Hiển thị danh sách sản phẩm
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order.orderDetails.length,
              itemBuilder: (BuildContext context, int index) {
                OrderDetail orderDetail = order.orderDetails[index];
                return FutureBuilder<Product>(
                  future: orderDetail.getProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Product product = snapshot.data!;
                      return ListTile(
                        leading: Image.network(product.imageUrl),
                        title: Text(product.name),
                        subtitle: Text(
                            'Số lượng: ${orderDetail.quantity.toString()}'),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Lỗi khi tải thông tin sản phẩm');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            ),
            ListTile(
              title: Text('Tổng giá trị: ${order.total.toString()}'),
            ),
            ButtonBar(
              children: [
                if (order.status == 0)
                  ElevatedButton(
                    onPressed: () {
                      updateOrderStatusAndFetch(order.id, 1);
                    },
                    child: Text('Xác nhận'),
                  ),
                if (order.status == 1)
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Vận chuyển
                      updateOrderStatusAndFetch(order.id, 2);
                    },
                    child: Text('Vận chuyển'),
                  ),
                if (order.status == 2)
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Đã thanh toán
                      updateOrderStatusAndFetch(order.id, 3);
                    },
                    child: Text('Đã thanh toán'),
                  ),
                if (order.status != 5 || order.status != 3)
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Save
                      updateOrderStatusAndFetch(order.id, 5);
                    },
                    child: Text('Hủy đơn hàng'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
