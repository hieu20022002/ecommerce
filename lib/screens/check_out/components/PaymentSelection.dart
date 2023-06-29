import 'package:ecommerce/screens/check_out/components/PaymentMethodTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PaypalCheckout(
                      sandboxMode: true,
                      clientId: "AVeMldMgfSd5h7dLJx13nZdd23ZtsEle-jsiYzzhKk2kCeUFtgDYp1SJs3QBYDmMWaWOx_ghBCPMVehU",
                      secretKey: "ENzdZ6GH2DvEsvMNzUSKAO2g6AqbASBOKm2F6lvtb2ZfHgFxb7caDUJjtqyzi2bmux6FYprgXqycvFV0",
                      returnURL: "success.snippetcoder.com",
                      cancelURL: "cancel.snippetcoder.com",
                      transactions: const [
                        {
                          "amount": {
                            "total": '70',
                            "currency": "USD",
                            "details": {
                              "subtotal": '70',
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          // "payment_options": {
                          //   "allowed_payment_method":
                          //       "INSTANT_FUNDING_SOURCE"
                          // },
                          "item_list": {
                            "items": [
                              {
                                "name": "Apple",
                                "quantity": 4,
                                "price": '5',
                                "currency": "USD"
                              },
                              {
                                "name": "Pineapple",
                                "quantity": 5,
                                "price": '10',
                                "currency": "USD"
                              }
                            ],

                            // shipping address is not required though
                            //   "shipping_address": {
                            //     "recipient_name": "Raman Singh",
                            //     "line1": "Delhi",
                            //     "line2": "",
                            //     "city": "Delhi",
                            //     "country_code": "IN",
                            //     "postal_code": "11001",
                            //     "phone": "+00000000",
                            //     "state": "Texas"
                            //  },
                          }
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");
                      },
                      onError: (error) {
                        print("onError: $error");
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        print('cancelled:');
                      },
                    ),
                  ));
                },
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
