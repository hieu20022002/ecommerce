import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Product.dart';

class CartDetail {
  String productId;
  int quantity;

  CartDetail({
    required this.productId,
    required this.quantity,
  });

  factory CartDetail.fromMap(Map<String, dynamic> map) {
    return CartDetail(
      productId: map['product_id'],
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }

  Future<void> deleteProduct(String cartId, String productId) async {
    // Tìm giỏ hàng hiện tại của người dùng
    final cartDoc =
        await FirebaseFirestore.instance.collection('Cart').doc(cartId).get();
    if (!cartDoc.exists) {
      throw Exception('Cart does not exist');
    }

    // Lấy danh sách chi tiết giỏ hàng
    List<Map<String, dynamic>> cartDetails =
        List<Map<String, dynamic>>.from(cartDoc.data()!['cartDetails']);

    // Tìm chi tiết giỏ hàng chứa sản phẩm muốn xóa
    Map<String, dynamic> cartDetailMap = cartDetails.firstWhere(
        (element) => element['product_id'] == productId,
        orElse: () => Map<String, dynamic>.from({}));

    if (cartDetailMap.isEmpty) {
      throw Exception('Product does not exist in cart');
    }

    // Xóa sản phẩm khỏi chi tiết giỏ hàng
    cartDetails.remove(cartDetailMap);

    // Cập nhật giỏ hàng trên Firestore
    await FirebaseFirestore.instance.collection('Cart').doc(cartId).update({
      'cartDetails': cartDetails,
    });
  }

  Future<Product> getProduct() async {
    // Lấy thông tin sản phẩm từ ID của chi tiết giỏ hàng
    final productDoc = await FirebaseFirestore.instance
        .collection('Products')
        .doc(productId)
        .get();
    if (!productDoc.exists) {
      throw Exception('Product does not exist');
    }

    // Tạo đối tượng sản phẩm từ dữ liệu tìm được
    return Product.fromFirestore(productDoc);
  }
}
