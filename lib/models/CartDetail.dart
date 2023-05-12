class CartDetail {
  final int productId;
  final int quantity;

  CartDetail({
    required this.productId,
    required this.quantity,
  });

  factory CartDetail.fromMap(Map<String, dynamic> map) {
    return CartDetail(
      productId: map['product_id'] ?? 0,
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}