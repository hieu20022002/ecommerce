import 'package:ecommerce/screens/MyOrder_Management/my_order_management.dart';
import 'package:ecommerce/screens/check_out/components/PaymentMethodTile.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';


class PaymentMethodSelection extends StatelessWidget {
  final double totalPrice;
  int get totalPriceInUSD => (totalPrice / 23584).toInt();
  final VoidCallback onCheckoutPressed;
  const PaymentMethodSelection({
    super.key,
    required this.totalPrice, required this.onCheckoutPressed,
  });

  void handlePayPalCheckout(BuildContext context) {
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId:
              "AVeMldMgfSd5h7dLJx13nZdd23ZtsEle-jsiYzzhKk2kCeUFtgDYp1SJs3QBYDmMWaWOx_ghBCPMVehU",
          secretKey:
              "ENzdZ6GH2DvEsvMNzUSKAO2g6AqbASBOKm2F6lvtb2ZfHgFxb7caDUJjtqyzi2bmux6FYprgXqycvFV0",
          returnURL: "success.snippetcoder.com",
          cancelURL: "cancel.snippetcoder.com",
          transactions:  [
            {
              "amount": {
                "total": totalPriceInUSD.toString(),
                "currency": "USD",
              },
              "description": "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) {
            // Handle the payment approval
            print("onSuccess: $params");
            onCheckoutPressed();
            
            
          },
          onCancel: () {
            // Handle payment cancellation
            print("Payment cancelled");
            Navigator.pop(context);
          },
          onError: (error) {
            // Handle payment error
            print("Payment error: $error");
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

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
              GestureDetector(
                onTap: () => handlePayPalCheckout(context),
                child: PaymentMethodTile(
                  icon: Icons.payment,
                  label: "PayPal",
                ),
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
