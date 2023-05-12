
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/CartDetail.dart';

class Cart {
  String? id;
  String? userId;
  double? total;
  List<CartDetail>? cartDetails;

  Cart({
    this.id,
    this.userId,
    this.total,
    this.cartDetails,
  });

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List cartDetailsList = data['cartDetails'] ?? [];

    return Cart(
      id: doc.id,
      userId: data['user_id'] ?? '',
      total: (data['total'] ?? 0.0).toDouble(),
      cartDetails: cartDetailsList
          .map((detail) => CartDetail.fromMap(detail))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'total': total,
      'cartDetails': cartDetails?.map((detail) => detail.toMap()).toList() ?? [],
    };
  }
  Future<void> save() async {
    final data = toMap();

    if (this.id != null) {
      await FirebaseFirestore.instance.collection('Cart').doc(this.id).update(data);
    } else {
      final docRef = await FirebaseFirestore.instance.collection('Cart').add(data);
      this.id = docRef.id;
    }
  }
}