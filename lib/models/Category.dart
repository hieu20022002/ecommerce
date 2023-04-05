import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  Category({required this.name});
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      name: data['name'],
    );
  }
  List<Category> categories = [];
}
