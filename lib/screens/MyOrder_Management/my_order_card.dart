import 'package:flutter/material.dart';
import '../../models/Address.dart';
import '../../models/Order.dart';
import '../../models/OrderDetail.dart';
import '../../models/Product.dart';
import '../Order_Management/components/Order_Status_Widget.dart';

class MyOrderCard extends StatelessWidget {
  MyOrderCard({
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
              future: Address.getById(order.addressId),
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
