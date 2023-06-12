import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String? id;
  String? userId;
  String? receiver;
  String? phoneNumber;
  String? addressLine;

  Address({this.id, this.userId, this.receiver, this.phoneNumber, this.addressLine});

  factory Address.fromDocument(DocumentSnapshot doc) {
    return Address(
      id: doc.id,
      userId: doc['user_id'],
      receiver: doc['receiver'],
      phoneNumber: doc['phonenumber'],
      addressLine: doc['address_line'],
    );
  }

  static Future<Address> getById(String id) async {
    final snapshot = await FirebaseFirestore.instance.collection('Address').doc(id).get();
    if (!snapshot.exists) {
      throw Exception('Address does not exist');
    }
    return Address.fromDocument(snapshot);
  }

  static Future<List> getByUserId(int userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('Address').where('user_id', isEqualTo: userId).get();
    final addresses = [];

    for (final doc in snapshot.docs) {
      addresses.add(Address.fromDocument(doc));
    }

    return addresses;
  }

  Future<void> save() async {
    final data = {
      'user_id': this.userId,
      'receiver': this.receiver,
      'phonenumber': this.phoneNumber,
      'address_line': this.addressLine,
    };

    if (this.id != null) {
      await FirebaseFirestore.instance.collection('Address').doc(this.id).update(data);
    } else {
      final docRef = await FirebaseFirestore.instance.collection('Address').add(data);
      this.id = docRef.id;
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('Address').doc(this.id).delete();
  }
}