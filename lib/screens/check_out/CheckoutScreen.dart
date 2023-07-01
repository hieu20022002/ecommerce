import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/CartDetail.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/models/Voucher.dart';
import 'package:ecommerce/screens/check_out/components/NotificatonMessage.dart';
import 'package:ecommerce/screens/check_out/components/OrderDetail.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
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
  final Voucher? selectedDiscountVoucher;
  final Voucher? selectedShippingVoucher;

  const CheckoutScreen({
    required this.cartController,
    this.selectedDiscountVoucher,
    this.selectedShippingVoucher,
  });

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

  double calculateTotalPayment() {
    double merchandiseSubtotal = widget.cartController.cart.total;
    double shippingSubtotal = 20000;

    double total = merchandiseSubtotal + shippingSubtotal;

    // Áp dụng chiết khấu từ Voucher giảm giá sản phẩm nếu có
    if (widget.selectedDiscountVoucher != null) {
      total -=
          merchandiseSubtotal * widget.selectedDiscountVoucher!.discount / 100;
    }

    // Áp dụng chiết khấu từ Voucher giảm giá vận chuyển nếu có
    if (widget.selectedShippingVoucher != null) {
      total -= shippingSubtotal;
    }

    return total;
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
      total: calculateTotalPayment(),
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
      status: 0, // Mặc định status là '0'
      orderDetails:
          mapCartDetailsToOrderDetails(widget.cartController.cart.cartDetails),
    );

    // Lưu đối tượng Order vào cơ sở dữ liệu
    await order.save();
    // Xóa các sản phẩm trong giỏ hàng
    for (CartDetail cartDetail in widget.cartController.cart.cartDetails) {
      await cartDetail.deleteProduct(
          widget.cartController.cart.id, cartDetail.productId);
    }

    // Hiển thị thông báo thành công hoặc thực hiện các xử lý khác sau khi lưu thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully')),
    );
  }

  void handleCheckouPayPal() async {
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
      orderDetails:
          mapCartDetailsToOrderDetails(widget.cartController.cart.cartDetails),
    );

    // Lưu đối tượng Order vào cơ sở dữ liệu
    await order.save();
    // Xóa các sản phẩm trong giỏ hàng
    for (CartDetail cartDetail in widget.cartController.cart.cartDetails) {
      await cartDetail.deleteProduct(
          widget.cartController.cart.id, cartDetail.productId);
    }
    Navigator.pushNamed(context, HomeScreen.routeName);
  }

  void updateSelectedAddress(Address address) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            NotificationMessage(
              message:
                  "Đơn hàng có thể giao ngoài giờ làm việc hoặc cuối tuần để đến tay bạn sớm nhất có thể. Bạn kiểm tra kỹ địa chỉ trước khi đặt hàng nhé.",
            ),
            Container(
              height: 10,
              color: Color.fromARGB(255, 235, 233, 233),
            ),
            DeliveryAddress(
              selectedAddress: selectedAddress,
              userId: widget.cartController.cart.userId,
              onAddressSelected: updateSelectedAddress,
            ),
            Separator(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.cartController.cart.cartDetails.length,
              itemBuilder: (context, index) {
                return ProductCard(
                    cartdetail: widget.cartController.cart.cartDetails[index]);
              },
            ),
            ShippingOption(
              option: "Fast",
              estimatedDeliveryTime: "July 3 - July 6",
              shippingFee: 20000,
            ),
            PaymentMethodSelection(
              totalPrice: widget.cartController.cart.total,
              onCheckoutPressed: handleCheckouPayPal,
            ),
            OrderDetails(
              merchandiseSubtotal: widget.cartController.cart.total,
              shippingSubtotal: 20000,
              selectedDiscountVoucher: widget.selectedDiscountVoucher,
              selectedShippingVoucher: widget.selectedShippingVoucher,
            ),
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        totalPrice: calculateTotalPayment(),
        onCheckoutPressed: handleCheckout,
      ),
    );
  }
}
