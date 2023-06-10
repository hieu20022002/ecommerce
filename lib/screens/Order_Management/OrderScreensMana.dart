import 'package:ecommerce/controller/OrderController.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/models/OrderDetail.dart';
import 'package:ecommerce/models/Product.dart';
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

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      List<Order> orders = await Order.getOrders();
      orderController.order(orders);
      setState(() {}); // Gọi phương thức fetchOrder để lấy danh sách hóa đơn
    } catch (error) {
      print('Error fetching orders: $error');
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
                return OrderCard(order: orderController.orders[index]);
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
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
