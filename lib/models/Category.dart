import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name, image;

  Category({required this.name, required this.image});
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      name: data['name'],
      image: data['image'],
    );
  }
  List<Category> categories = [];
}
