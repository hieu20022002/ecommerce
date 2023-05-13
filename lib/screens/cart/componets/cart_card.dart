import 'package:ecommerce/models/CartDetail.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import '../../constants.dart';


class CartCard extends StatelessWidget {
  final CartDetail cartdetail;
  const CartCard({
    Key? key,
    required this.cartdetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: cartdetail.getProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final product = snapshot.data!;
          return Row(
            children: [
              SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(product.imageUrl),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text:
                            "${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}\đ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor),
                        children: [
                          TextSpan(
                              text: " x${cartdetail.quantity.toString()}",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}