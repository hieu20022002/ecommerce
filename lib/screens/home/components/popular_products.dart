import 'package:ecommerce/components/product_card.dart';
import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
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
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                topProducts.length,
                (index) {
                  if (topProducts[index].status==1)
                    return ProductCard(product: topProducts[index]);
                  else
                    return SizedBox.shrink(); // here by default width and height is 0
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
