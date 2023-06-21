import 'package:flutter/material.dart';

import 'NewAddress.dart';

class DeliveryAddress extends StatelessWidget {
  final String address;

  const DeliveryAddress({required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressSelection()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_shipping,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                address,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressSelection extends StatefulWidget {
  @override
  _AddressSelectionState createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  // A list of sample addresses
  final List<String> addresses = [
    '123 Main Street',
    '456 Elm Avenue',
    '789 Pine Road',
    '1011 Maple Lane',
    '1213 Oak Drive'
  ];

  // A variable to store the selected address value for each group
  String? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Address Selection',
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
      body: Column(
        children: [
          // A listview builder to create the radio buttons for each address
          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(addresses[index]),
                  value: addresses[index],
                  groupValue: selectedAddress,
                  onChanged: (value) {
                    setState(() {
                      selectedAddress = value;
                    });
                  },
                );
              },
            ),
          ),
          // A list tile to create the "Add New Address" option
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add New Address'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewAddress()),
              );
            },
          )
        ],
      ),
    );
  }
}
