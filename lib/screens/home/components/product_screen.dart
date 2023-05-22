import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/components/custom_appbar.dart';
import 'package:ecommerce/size_config.dart';
import '../../../components/custom_navbar.dart';
import '../../../enums.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String classificationType;
  final String classificationValue;

  const ProductsScreen({
    Key? key,
    required this.classificationType,
    required this.classificationValue,
  }) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> products;
  final productController = ProductController();

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    await productController.fetchProducts();

    switch (widget.classificationType) {
      case 'category':
        return productController
            .getProductsByCategory(widget.classificationValue);
      case 'brand':
        return productController.getProductsByBrand(widget.classificationValue);
      default:
        return [];
    }
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      children: products.map((product) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: ProductDetailsArguments(product: product),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${NumberFormat('#,###').format(product.price)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + getProportionateScreenHeight(20)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(40)),
            CustomAppBar(Title: widget.classificationValue),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
        child: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error fetching products: ${snapshot.error}'));
            } else {
              final products = snapshot.data;
              if (products != null && products.isNotEmpty) {
                return _buildProductGrid(products);
              } else {
                return Center(child: Text('No products found.'));
              }
            }
          },
        ),
      ),
      bottomNavigationBar: CustomNavBar(selectedMenu: MenuState.home),
    );
  }
}
