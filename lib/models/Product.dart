import 'package:cloud_firestore/cloud_firestore.dart';
class Product{
  String id;
  String name;
  String description;
  String imageUrl;
  String brandId;
  String categoryId;
  String couponId;
  int status;
  int price;
  int quantity;
  DateTime createdDate;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.brandId,
    required this.categoryId,
    required this.couponId,
    required this.status,
    required this.price,
    required this.quantity,
    required this.createdDate,
  });
  factory Product.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      brandId: data['brand_id'],
      categoryId: data['category_id'],
      couponId: data['coupon_id'],
      status: data['status'],
      price: data['price'],
      quantity: data['quantity'],
      createdDate: data['createdDate'].toDate(),
    );
  }

  static Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Products').get();
    List<Product> products = querySnapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();
    return products;
  }
}