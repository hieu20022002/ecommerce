import 'package:cloud_firestore/cloud_firestore.dart';
class Review {
  String? id;
  String? userId;
  String? productId;
  String? title;
  String? body;
  int? rating;

  Review({this.id, this.userId, this.productId, this.title, this.body, this.rating});

  factory Review.fromDocument(DocumentSnapshot doc) {
    return Review(
      id: doc.id,
      userId: doc['user_id'],
      productId: doc['product_id'],
      title: doc['title'],
      body: doc['body'],
      rating: doc['rating'],
    );
  }

  static Future<Review> getById(String id) async {
    final snapshot = await FirebaseFirestore.instance.collection('Review').doc(id).get();
    if (!snapshot.exists) {
      throw Exception('Review does not exist');
    }
    return Review.fromDocument(snapshot);
  }

  Future<void> save() async {
    final data = {
      'user_id': this.userId,
      'product_id': this.productId,
      'title': this.title,
      'body': this.body,
      'rating': this.rating,
    };

    if (this.id != null) {
      await FirebaseFirestore.instance.collection('Review').doc(this.id).update(data);
    } else {
      final docRef = await FirebaseFirestore.instance.collection('Review').add(data);
      this.id = docRef.id;
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('Review').doc(this.id).delete();
  }

  static Future<List<Review>> getReviewsByUserIdAndProductId(String userId, String productId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Review')
        .where('user_id', isEqualTo: userId)
        .where('product_id', isEqualTo: productId)
        .get();
    final reviews = snapshot.docs.map((doc) => Review.fromDocument(doc)).toList();
    return reviews;
  }

}
