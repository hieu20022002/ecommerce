import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/controller/ProductController.dart';
import 'package:ecommerce/models/CartDetail.dart';
import 'package:ecommerce/models/Product.dart';

class Cart {
  String id;
  String userId;
  double total;
  List<CartDetail> cartDetails;

  Cart({
    required this.id,
    required this.userId,
    required this.total,
    required this.cartDetails,
  });

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> cartDetailsList =
        List<Map<String, dynamic>>.from(data['cartDetails'] ?? []);

    return Cart(
      id: doc.id,
      userId: data['user_id'],
      total: (data['total'] ?? 0.0).toDouble(),
      cartDetails:
          cartDetailsList.map((detail) => CartDetail.fromMap(detail)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'total': total,
      'cartDetails': cartDetails.map((detail) => detail.toMap()).toList(),
    };
  }

  Future<void> save() async {
    final data = toMap();

    if (this.id != '') {
      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(this.id)
          .update(data);
    } else {
      final docRef =
          await FirebaseFirestore.instance.collection('Cart').add(data);
      this.id = docRef.id;
    }
  }

  static Future<Cart> getCart(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Cart')
        .where('user_id', isEqualTo: userId)
        .get();

    Cart cart =
        querySnapshot.docs.map((doc) => Cart.fromFirestore(doc)).toList()[0];
    return cart;
  }

  Future<void> deleteProduct(String userId, String productId) async {
    // Get the cart of the user
    Cart cart = await getCart(userId);

    // Find the index of the product in the cart details list
    int index =
        cart.cartDetails.indexWhere((detail) => detail.productId == productId);

    // If the product is found, remove it from the cart details list
    if (index != -1) {
      cart.cartDetails.removeAt(index);
      cart.cartDetails[index].deleteProduct(userId, productId);
      cart.total = calculateTotal(cart.cartDetails);
      await cart.save();
    }
  }

  double calculateTotal(List<CartDetail> cartDetails) {
    ProductController productController = ProductController();
    productController.fetchProducts();
    double total = 0.0;
    cartDetails.forEach((detail) {
      total += detail.quantity *
          productController.products
              .firstWhere((product) => product.id == detail.productId)
              .price;
    });
    return total;
  }
}
