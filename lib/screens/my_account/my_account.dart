import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/User.dart' as MyUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  static String routeName = "/my_account";
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Khai báo các biến để lưu thông tin người dùng
  MyUser.User myaccount = new MyUser.User();

  // Khai báo các biến để lưu thông tin người dùng khi cập nhật
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      
      DocumentSnapshot snapshot =
          await _firestore.collection('User').doc(user.uid).get();
      myaccount.fromDocumentSnapshot(snapshot);
      setState(() {});
    }
  }
    // Hàm để cập nhật thông tin người dùng
  void _updateUserInfo() async {
    
    if (myaccount != null) {
      myaccount.modified_at=DateTime.now();
      myaccount.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Text(
            "Edit Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(myaccount.email.toString()),
          ),
          ListTile(
            title: Text('First Name'),
            subtitle: TextField(
              controller: TextEditingController(text: myaccount.firstName),
               onChanged: (value){
                myaccount.firstName = value;
               }),
          ),
          ListTile(
            title: Text('Last Name'),
            subtitle: TextField(
              controller: TextEditingController(text: myaccount.lastName),
               onChanged: (value){
                myaccount.lastName = value;
               }),
          ),
          ListTile(
            title: Text('Phone Number'),
            subtitle: TextField(
              controller: TextEditingController(text: myaccount.phonenumber),
               onChanged: (value){
                myaccount.phonenumber = value;
               }),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: _updateUserInfo,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.3)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
