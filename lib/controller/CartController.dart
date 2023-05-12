import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Cart.dart';
import 'package:ecommerce/models/CartDetail.dart';
import 'package:flutter/cupertino.dart';


class CartController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartDetail> _cartDetails = [];
  double _total = 0;

  List<CartDetail> get cartDetails => _cartDetails;
  double get total => _total;
}
