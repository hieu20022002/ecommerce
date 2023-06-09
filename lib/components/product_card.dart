import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/screens/constants.dart';
import 'package:ecommerce/screens/details/details_screen.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRatio;
  final Product product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _showImage;

  @override
  void initState() {
    super.initState();
    _showImage = true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(widget.width),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            DetailsScreen.routeName,
            arguments: ProductDetailsArguments(product: widget.product),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _showImage
                        ? Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.contain,
                            key: ValueKey(widget.product.id),
                          )
                        : Container(
                            key: ValueKey(widget.product.id),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.name,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    NumberFormat('#,###', 'vi_VN')
                            .format(widget.product.price) +
                        "\₫",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
