import 'package:ecommerce/models/Category.dart';
import 'package:flutter/material.dart';


class CategoryController extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  set categories(List<Category> value) {
    _categories = value;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    List<Category> categories = await Category.getCategories();
    this.categories = categories;
  }
  List<Category> getCategories() {
    return _categories;
  }
}
