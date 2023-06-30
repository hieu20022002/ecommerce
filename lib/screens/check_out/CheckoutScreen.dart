import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/CartDetail.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/screens/check_out/components/NotificatonMessage.dart';
import 'package:flutter/material.dart';
import '../../models/OrderDetail.dart';
import 'DeliveryAddress/DeliveryAddress.dart';
import 'components/Navbar.dart';
import 'components/PaymentSelection.dart';
import 'components/Product_cart.dart';
import 'components/Separator.dart';
import 'components/ShippingOption.dart';

class CheckoutScreen extends StatefulWidget {
  final CartController cartController;
  const CheckoutScreen({required this.cartController});
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address selectedAddress = Address();
  List<OrderDetail> mapCartDetailsToOrderDetails(List<CartDetail> cartDetails) {
  List<OrderDetail> orderDetails = [];

  for (CartDetail cartDetail in cartDetails) {
    OrderDetail orderDetail = OrderDetail(
      productId: cartDetail.productId,
      quantity: cartDetail.quantity,
    );

    orderDetails.add(orderDetail);
  }

  return orderDetails;
}
  void handleCheckout() async {
      if (selectedAddress.id == null) {
    // Hiển thị thông báo yêu cầu chọn địa chỉ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vui lòng chọn địa chỉ giao hàng')),
    );
    return;
  }
  // Thực hiện xử lý lưu thông tin đơn hàng và đơn hàng chi tiết vào cơ sở dữ liệu
  // Lấy thông tin từ widget.cartController và selectedAddress

  // Tạo một đối tượng Order mới
  Order order = Order(
    id: '',
    userId: widget.cartController.cart.userId,
    paymentId: '', // Mặc định là thanh toán khi nhận hàng
    addressId: selectedAddress.id.toString(),
    total: widget.cartController.cart.total,
    createdAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    status: 0, // Mặc định status là '0'
    orderDetails:  mapCartDetailsToOrderDetails(widget.cartController.cart.cartDetails),
  );

  // Lưu đối tượng Order vào cơ sở dữ liệu
  await order.save();
  // Xóa các sản phẩm trong giỏ hàng
  for (CartDetail cartDetail in widget.cartController.cart.cartDetails) {
    await cartDetail.deleteProduct(widget.cartController.cart.id, cartDetail.productId);
  }

  // Hiển thị thông báo thành công hoặc thực hiện các xử lý khác sau khi lưu thành công
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Order placed successfully')),
  );
}


  void updateSelectedAddress(Address  address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelectedAddress = selectedAddress.id != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: Text(
          "Check Out",
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
      body: Column(
        children: [
          NotificationMessage(
            message:
                "Đơn hàng có thể giao ngoài giờ làm việc hoặc cuối tuần để đến tay bạn sớm nhất có thể. Bạn kiểm tra kỹ địa chỉ trước khi đặt hàng nhé.",
          ),
          Container(
            height: 10,
            color: Color.fromARGB(255, 235, 233, 233),
          ),
          DeliveryAddress(selectedAddress: selectedAddress, userId: widget.cartController.cart.userId, onAddressSelected: updateSelectedAddress),
          Separator(),
                    Expanded(
            child: ListView.builder(
              itemCount: widget.cartController.cart.cartDetails.length,
              itemBuilder: (context, index) {
                return ProductCard(cartdetail: widget.cartController.cart.cartDetails[index]);
              },
            ),
          ),
          // ShippingOption(
          //   option: "Fast",
          //   estimatedDeliveryTime: "June 15 - June 18",
          //   shippingFee: widget.cartController.cart.total,
          // ),
          PaymentMethodSelection(totalPrice: widget.cartController.cart.total, onCheckoutPressed: handleCheckout),
          Expanded(
            child: Container(),
          ),
          Navbar(
            totalPrice: widget.cartController.cart.total,
            onCheckoutPressed: handleCheckout,
          ),
        ],
      ),
    );
  }
}
