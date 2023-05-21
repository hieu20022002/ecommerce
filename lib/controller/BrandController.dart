import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Brand.dart';
import 'package:flutter/material.dart';

class BrandController extends ChangeNotifier {
  List<Brand> _brands = [];
  int countProduct = 0;
  
  List<Brand> get brands => _brands;

  set brands(List<Brand> value) {
    _brands = value;
    notifyListeners();
  }

  Future<void> fetchBrands() async {
    List<Brand> brands = await Brand.getBrands();
    this.brands = brands;
  }
  Future<void> ProductCountByBrand(String brandId)  async {
    final temp =Brand.CountByBrand(brandId);
    this.countProduct = await temp;
  }
  int getProductCountByBrand(String brandId){
    ProductCountByBrand(brandId);
    return this.countProduct;
  }
  
}
