import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name,id,icon;

  Category({required this.name, required this.id, required this.icon});
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'],
      icon: data['icon'],
    );
  }
    static Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Category').get();
    List<Category> categories = querySnapshot.docs
        .map((doc) => Category.fromFirestore(doc))
        .toList();
    return categories;
  }

}
