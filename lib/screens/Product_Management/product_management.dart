import 'package:ecommerce/components/custom_appbar.dart';
import 'package:ecommerce/components/custom_navbar.dart';
import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/enums.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/screens/Product_Management/editproduct.dart';
import 'package:ecommerce/screens/details/details_screen.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductsManagerScreen extends StatefulWidget {
  const ProductsManagerScreen({Key? key}) : super(key: key);

  @override
  _ProductsManagerScreenState createState() => _ProductsManagerScreenState();
}

class _ProductsManagerScreenState extends State<ProductsManagerScreen> {
  List<Product> products = [];
  final productController = ProductController();
  bool isLoading = true; // Variable to check loading state

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      await productController.fetchProducts();
      List<Product> products = productController.getTopProductsByCreateDate();
      setState(() {
        this.products = products;
      });
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      isLoading = false; // Set loading state to false after data is loaded
    }
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      children: products.map((product) {
        return GestureDetector(
          onTap: () {
              Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProductScreen(product: product),
    ),
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
                        NumberFormat('#,###', 'vi_VN').format(product.price) + "\₫",
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
      appBar: AppBar(
        title: Text('Product Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_product');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : products.isNotEmpty
                ? _buildProductGrid(products)
                : Center(child: Text('No products found.')),
      ),
    );
  }
}
