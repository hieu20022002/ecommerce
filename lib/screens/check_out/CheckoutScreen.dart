import 'package:ecommerce/controller/CartController.dart';
import 'package:flutter/material.dart';

import 'DeliveryAddress/DeliveryAddress.dart';

class NotificationMessage extends StatelessWidget {
  final String message;

  const NotificationMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Transform(
                transform: Matrix4.skewX(-0.2),
                child: Container(
                  width: 40,
                  color: index % 2 == 0 ? Colors.blue : Colors.red,
                ),
              ),
              SizedBox(width: 5),
            ],
          );
        },
      ),
    );
  }
}

class PaymentMethodSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              PaymentMethodTile(
                icon: Icons.credit_card,
                label: "Credit Card",
              ),
              SizedBox(width: 10),
              PaymentMethodTile(
                icon: Icons.payment,
                label: "PayPal",
              ),
              SizedBox(width: 10),
              PaymentMethodTile(
                icon: Icons.monetization_on,
                label: "Cash on Delivery",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const PaymentMethodTile({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

class ShippingOption extends StatelessWidget {
  final String option;
  final String estimatedDeliveryTime;
  final double shippingFee;

  const ShippingOption({
    required this.option,
    required this.estimatedDeliveryTime,
    required this.shippingFee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping Option",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            option,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Receive by $estimatedDeliveryTime",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\$$shippingFee",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Navbar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckoutPressed;

  const Navbar({
    required this.totalPrice,
    required this.onCheckoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: \$${totalPrice.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: onCheckoutPressed,
            child: Text("Checkout"),
          ),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  static String routeName = "/checkout";

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddress = '';

  void updateSelectedAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          DeliveryAddress(selectedAddress: selectedAddress),
          Separator(),
          ShippingOption(
            option: "Fast",
            estimatedDeliveryTime: "June 15 - June 18",
            shippingFee: 9.99,
          ),
          PaymentMethodSelection(),
          Expanded(
            child: Container(),
          ),
          Navbar(
            totalPrice: 99.99,
            onCheckoutPressed: () {},
          ),
        ],
      ),
    );
  }
}
