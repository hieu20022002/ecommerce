import 'package:ecommerce/components/product_card.dart';
import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/screens/home/components/section_title.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';

class TopNewProducts extends StatefulWidget {
  @override
  _TopNewProductsState createState() => _TopNewProductsState();
}

class _TopNewProductsState extends State<TopNewProducts> {
  final productController = ProductController();
  List<Product> topProducts = [];

  @override
  void initState() {
    super.initState();
    fetchTopProducts();
  }

  Future<void> fetchTopProducts() async {
    await productController.fetchProducts();
    topProducts = productController.getTopProductsByCreateDate();
    setState(() {}); // Rebuild the widget tree to display the fetched products
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "New Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                topProducts.length,
                (index) {
                  if (topProducts[index].status == 1) {
                    return ProductCard(product: topProducts[index]);
                  } else {
                    return SizedBox
                        .shrink(); // here by default width and height is 0
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}