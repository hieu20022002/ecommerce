import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Category.dart';

class CategoryController {
  static Future<List<Category>> getCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Category').get();
    return querySnapshot.docs
        .map((doc) => Category.fromFirestore(doc))
        .toList();
  }
}