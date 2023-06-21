import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
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
  factory Product.fromFirestore(DocumentSnapshot doc) {
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
    List<Product> products =
        querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    return products;
  }

  static Future<Product> getProductById(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('Products').doc(id).get();
    if (!doc.exists) {
      throw Exception('Product does not exist');
    }
    return Product.fromFirestore(doc);
  }


  static Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection("Products")
          .where("category_id", isEqualTo: categoryId)
          .get();
      List<Product> products = productSnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
      return products;
    } catch (error) {
      print('Error fetching products by category: $error');
    }
    return [];
  }

  static Future<List<Product>> getProductsByBrand(String brandId) async {
    List<Product> products = [];
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection("Products")
          .where("brand_id", isEqualTo: brandId)
          .get();
      products = productSnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (error) {
      print('Error fetching products by brand: $error');
    }
    return products;
  }
    static Future<void> addProduct(Product product) async {
    try {
      // Thêm sản phẩm vào Firestore
      await FirebaseFirestore.instance.collection('Products').add({
        'name': product.name,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'brand_id': product.brandId,
        'category_id': product.categoryId,
        'coupon_id': product.couponId,
        'status': product.status,
        'price': product.price,
        'quantity': product.quantity,
        'createdDate': product.createdDate,
      });
    } catch (error) {
      print('Error adding product: $error');
      throw Exception('Failed to add product');
    }
  }
}
