import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Cart.dart';
import 'package:flutter/cupertino.dart';

class CartController extends ChangeNotifier {
  Cart _cart = new Cart(cartDetails: [], total: 0, userId: '', id: '');
  Cart get cart => _cart;
  set cart(Cart value) {
    _cart = value;
    notifyListeners();
  }

  Future<void> fetchCart(String userId) async {
    Cart giohang = await Cart.getCart(userId);
    this.cart=giohang;
    notifyListeners();
  }
  Future<void> deleteProductByIdandUserID(String productId,String userId) async {
    await _cart.deleteProduct(userId, productId);
  }

  Future<void> addProductToCart(String userId, String productId,int quantity) async {
    await _cart.AddProducttoCart(userId, productId, quantity);
  }


}
