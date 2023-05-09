import 'package:flutter/material.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:flutter/material.dart';
class ProductController extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void setProducts(List<Product> products) {
    for( var i=0; i < products.length; i++ ) {
      _products.add(products[i]);
    }
    notifyListeners();
  }
  Future<void> fetchProducts() async {
    try {
      List<Product> products = await Product.getProducts();
      setProducts(products);
    } catch (error) {
      // Handle the error appropriately for your app
      print('Error fetching products: $error');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      // Add the product to Firestore, then update the local list
      // You'll need to define the Firestore logic yourself
      // Once you've added the product to Firestore, you can add it to the local list:
      _products.add(product);
      notifyListeners();
    } catch (error) {
      // Handle the error appropriately for your app
      print('Error adding product: $error');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      // Update the product in Firestore, then update the local list
      // You'll need to define the Firestore logic yourself
      // Once you've updated the product in Firestore, you can update it in the local list:
      int index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (error) {
      // Handle the error appropriately for your app
      print('Error updating product: $error');
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      // Delete the product from Firestore, then update the local list
      // You'll need to define the Firestore logic yourself
      // Once you've deleted the product from Firestore, you can delete it from the local list:
      _products.removeWhere((p) => p.id == product.id);
      notifyListeners();
    } catch (error) {
      // Handle the error appropriately for your app
      print('Error deleting product: $error');
    }
  }

  List<Product> getTopProductsByCreateDate() {
    List<Product> sortedProducts = _products;
    sortedProducts.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return sortedProducts;
  }
}
