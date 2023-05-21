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
  final String categoryName;

  const ProductsScreen({Key? key, required this.categoryName})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future<List<Product>>? productsByCategory;
  final productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    await productController.fetchProducts();
    productsByCategory =
        productController.getProductsByCategory(widget.categoryName);
    setState(() {}); // Rebuild the widget tree to display the fetched products
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
            CustomAppBar(Title: widget.categoryName),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
        child: FutureBuilder<List<Product>>(
          future: productsByCategory,
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
                        NumberFormat('#,###', 'vi_VN').format(product.price) +
                            ' ₫',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
}
