import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phonenumber;
  String? password;
  DateTime? created_at;
  DateTime? modified_at;
  String? image_url;
  int? code;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phonenumber,
    this.password,
    this.created_at,
    this.modified_at,
    this.image_url,
    this.code,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phonenumber: data['phonenumber'],
      password: data['password'],
      created_at: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
      modified_at: data['modified_at'] != null
          ? DateTime.parse(data['modified_at'])
          : null,
      image_url: data['image_url'],
      code: data['code'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phonenumber': phonenumber,
      'password': password,
      'created_at': created_at != null ? created_at?.toIso8601String() : null,
      'modified_at':
          modified_at != null ? modified_at?.toIso8601String() : null,
      'image_url': image_url,
      'code': code,
    };
  }
    void fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      id = snapshot.id;
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      email = data['email'] ?? '';
      phonenumber = data['phonenumber'] ?? '';
      password = data['password'] ?? '';
      created_at = data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null;
      modified_at = data['modified_at'] != null
          ? DateTime.parse(data['modified_at'])
          : null;
      image_url = data['image_url'] ?? '';
      code = data['code'] ?? 0;
    }
  }

  static Future<User?> getById(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data() as Map<String, dynamic>;
    return User.fromDocument(snapshot);
  }

  static Future<User?> getByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }

    final data = snapshot.docs.first.data() as Map<String, dynamic>;
    return User.fromDocument(snapshot.docs.first);
  }

  Future<void> save() async {
    final data = toDocument();

    if (id != null) {
      await FirebaseFirestore.instance.collection('User').doc(id).update(data);
    } else {
      final docRef = await FirebaseFirestore.instance.collection('User').add(data);
      id = docRef.id;
    }
  }
  Future<void> SignUp() async {
    final data = toDocument();

    final docRef =
        await FirebaseFirestore.instance.collection('User').doc(id).set(data);
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('User').doc(id).delete();
  }
}
