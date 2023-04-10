import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name, id;

  Category({required this.name, required this.id});
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      name: data['name'],
      id: data['id'],
    );
  }
  List<Category> categories = [];
}
