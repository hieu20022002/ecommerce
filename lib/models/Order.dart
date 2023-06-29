import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/OrderDetail.dart';

class Order {
  String id;
  String userId;
  String paymentId;
  String addressId;
  double total;
  DateTime createdAt;
  DateTime modifiedAt;
  int status;
  List<OrderDetail> orderDetails;
  Order({
    required this.id,
    required this.userId,
    required this.paymentId,
    required this.addressId,
    required this.total,
    required this.createdAt,
    required this.modifiedAt,
    required this.status,
    required this.orderDetails,
  });
  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> orderDetailsList = data['orderDetails'] ?? [];
    return Order(
      id: doc.id,
      userId: data['user_id'],
      paymentId: data['payment_id'],
      addressId: data['address_id'],
      total: (data['total'] ?? 0.0).toDouble(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      modifiedAt: (data['modified_at'] as Timestamp).toDate(),
      status: data['status'],
      orderDetails: orderDetailsList
          .map((detail) => OrderDetail.fromMap(detail as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'payment_id': paymentId,
      'address_id': addressId,
      'total': total,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'status': status,
      'orderDetails': orderDetails.map((detail) => detail.toMap()).toList(),
    };
  }
    Future<void> save() async {
    final data = toMap();

    if (this.id != '') {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(this.id)
          .set(data);
    } else {
      final docRef =
          await FirebaseFirestore.instance.collection('Orders').add(data);
      this.id = docRef.id;
    }
  }
  static Future<List<Order>> getOrders() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Orders').get();
    List<Order> orders =
        querySnapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
    return orders;
  }



  static Future<void> updateStatusById(String orderId, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .update({'status': newStatus});
    } catch (error) {
      print('Lỗi khi cập nhật trạng thái đơn hàng: $error');
      // Xử lý lỗi theo yêu cầu của bạn
    }
  }

  static Future<List<Order>> getOrdersByUserId(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('user_id', isEqualTo: uid)
          .get();

      List<Order> orders =
          querySnapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
      return orders;
    } catch (error) {
      print('Error getting orders by user ID: $error');
      return [];
    }
  }
}
