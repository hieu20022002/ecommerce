import 'package:ecommerce/models/Review.dart';
import 'package:flutter/material.dart';

class ReviewController extends ChangeNotifier {
  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  set reviews(List<Review> value) {
    _reviews = value;
    notifyListeners();
  }

  static Future<List<Review>> getReviewsByUserIdAndProductId(String userId, String productId) async {
    List<Review> reviews = await Review.getReviewsByUserIdAndProductId(userId, productId);
    return reviews;
  }

}

