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
    List<dynamic> cartDetailsList = data['cartDetails'] ?? [];

    return Cart(
      id: doc.id,
      userId: data['user_id'],
      total: (data['total'] ?? 0.0).toDouble(),
      cartDetails: cartDetailsList
          .map((detail) => CartDetail.fromMap(detail as Map<String, dynamic>))
          .toList(),
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
          .set(data);
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
        querySnapshot.docs.map((doc) => Cart.fromFirestore(doc)).first;
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
      await FirebaseFirestore.instance.collection('Cart').doc(cart.id).update({
        'cartDetails':
            cart.cartDetails.map((detail) => detail.toMap()).toList(),
      });
    }
    cart.total = await calculateTotal(cart.cartDetails);
    await FirebaseFirestore.instance.collection('Cart').doc(cart.id).update({
      'total': cart.total,
    });
    await cart.save();
  }

  Future<double> calculateTotal(List<CartDetail> cartDetails) async {
    double total = 0.0;

    for (CartDetail detail in cartDetails) {
      int productPrice = await getProductPriceById(detail.productId);

      if (productPrice != 0) {
        total += detail.quantity * productPrice;
      }
    }

    return total;
  }

  Future<int> getProductPriceById(String productId) async {
    ProductController productController = ProductController();
    await productController.fetchProducts();
    Product product = productController.products.firstWhere(
      (product) => product.id == productId,
    );

    return product.price;
  }
}

