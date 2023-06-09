class OrderDetail {
  int orderId;
  int productId;
  int quantity;

  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.quantity,
  });
  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}