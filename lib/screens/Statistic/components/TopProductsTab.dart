import 'package:flutter/material.dart';
import 'package:ecommerce/models/Order.dart';
import 'package:ecommerce/models/OrderDetail.dart';
import 'package:ecommerce/models/Product.dart';

class TopProductsTab extends StatelessWidget {
  const TopProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Products',
          style: TextStyle(color: Colors.deepOrangeAccent),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: getTopProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<Product> products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Text('Không có sản phẩm nào');
          }
          Product topProduct = products.first;
          return Column(
            children: [
              FutureBuilder<int>(
                future: getQuantitySold(topProduct.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  int quantitySold = snapshot.data ?? 0;
                  return _createTopCard(
                    '1',
                    topProduct.imageUrl,
                    topProduct.name,
                    quantitySold.toString(),
                    '${topProduct.price * quantitySold}đ',
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length - 1,
                  itemBuilder: (context, index) {
                    Product product = products[index + 1];
                    return FutureBuilder<int>(
                      future: getQuantitySold(product.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        int quantitySold = snapshot.data ?? 0;
                        return _createCard(
                          (index + 2).toString(),
                          product.imageUrl,
                          product.name,
                          quantitySold.toString(),
                          '${product.price * quantitySold}đ',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Product>> getTopProducts() async {
    // Retrieve the list of orders
    List<Order> orders = await Order.getOrders();

    // Collect the order details from all orders
    List<OrderDetail> orderDetails =
        orders.expand((order) => order.orderDetails).toList();

    // Calculate the quantity sold for each product and store it in a map
    Map<String, int> productSoldMap = {};
    orderDetails.forEach((detail) {
      String productId = detail.productId;
      productSoldMap[productId] =
          (productSoldMap[productId] ?? 0) + detail.quantity;
    });

    // Retrieve the products
    List<Product> topProducts = await Product.getProducts();

    // Sort the products by quantity sold
    topProducts.sort((a, b) =>
        (productSoldMap[b.id] ?? 0).compareTo(productSoldMap[a.id] ?? 0));

    return topProducts;
  }

  Future<int> getQuantitySold(String productId) async {
    // Retrieve the list of orders
    List<Order> orders = await Order.getOrders();

    // Collect the order details from all orders
    List<OrderDetail> orderDetails =
        orders.expand((order) => order.orderDetails).toList();

    int quantitySold = 0;
    orderDetails.forEach((detail) {
      if (detail.productId == productId) {
        quantitySold += detail.quantity;
      }
    });
    return quantitySold;
  }

  Widget _createTopCard(
      String stt, String image, String name, String sold, String revenue) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown, width: 3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.network(
                      image,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('Đã bán: $sold', style: TextStyle(color: Colors.brown)),
                  Text('Doanh số: $revenue',
                      style: TextStyle(color: Colors.brown)),
                ],
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: Duration(milliseconds: 1000),
              builder: (BuildContext context, double size, Widget? child) {
                return Transform.scale(scale: size, child: child);
              },
              child: Card(
                color: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Sản phẩm được mua nhiều nhất',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCard(
      String stt, String image, String name, String sold, String revenue) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              stt,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Image.network(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text('Đã bán: $sold'),
                Text('Doanh số: $revenue'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
