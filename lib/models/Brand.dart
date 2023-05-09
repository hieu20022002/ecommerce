import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Brand {
  String id, name,  image;

  Brand({required this.id, required this.name, required this.image});

  factory Brand.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Brand(
      id: doc.id,
      name: data['name'],
      image: data['image'],
    );
  }

  static Future<List<Brand>> getBrands() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Brands').get();
    List<Brand> brands = querySnapshot.docs
        .map((doc) => Brand.fromFirestore(doc))
        .toList();
    return brands;
  }
  static Future<int> CountByBrand(String id) async {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('brand_id', isEqualTo: id)
        .get();
    return querySnapshot.docs.length;
  }
}