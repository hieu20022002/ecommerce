import 'package:ecommerce/screens/constants.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  static String routeName = "/my_account";
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  // Khai báo các biến để lưu thông tin người dùng
  String _email = 'example@gmail.com';
  String _fullName = 'Nguyễn Văn A';
  String _phoneNumber = '0987654321';
  String _address = '123 Đường ABC, Quận XYZ, Thành phố HCM';

  // Khai báo các biến để lưu thông tin người dùng khi cập nhật
  String _newPhoneNumber = '';
  String _newAddress = '';

  // Hàm để cập nhật thông tin người dùng
  void _updateUserInfo() {
    setState(() {
      if (_newPhoneNumber != '') {
        _phoneNumber = _newPhoneNumber;
        _newPhoneNumber = '';
      }
      if (_newAddress != '') {
        _address = _newAddress;
        _newAddress = '';
      }
    });
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
            style: headingStyle,
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(_email),
          ),
          ListTile(
            title: Text('Full Name'),
            subtitle: Text(_fullName),
          ),
          ListTile(
            title: Text('Phone Number'),
            subtitle: TextFormField(
              initialValue: _phoneNumber,
              onChanged: (value) {
                _newPhoneNumber = value;
              },
            ),
          ),
          ListTile(
            title: Text('Address'),
            subtitle: TextFormField(
              initialValue: _address,
              onChanged: (value) {
                _newAddress = value;
              },
            ),
          ),
          SizedBox(height: 20),
          //
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
