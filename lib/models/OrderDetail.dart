import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Product.dart';

class OrderDetail {
  String productId;
  int quantity;

  OrderDetail({
    required this.productId,
    required this.quantity,
  });
  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
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