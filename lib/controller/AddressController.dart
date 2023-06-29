import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Address.dart';

import 'package:flutter/material.dart';

class AddressController extends ChangeNotifier {
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;

  set addresses(List<Address> value) {
    _addresses = value;
    notifyListeners();
  }
  static Future<List<Address>> AddressByUserId(String userId) async {
    List<Address> addresses = await Address.getAddressByUserId(userId);
    return addresses;
  }
}
