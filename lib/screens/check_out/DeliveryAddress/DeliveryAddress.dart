import 'package:flutter/material.dart';

import 'NewAddress.dart';

class DeliveryAddress extends StatefulWidget {
  final String selectedAddress;

  DeliveryAddress({required this.selectedAddress});

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.selectedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressSelection()),
        );
        if (selected != null) {
          setState(() {
            selectedAddress = selected;
          });
        }
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
                selectedAddress.isNotEmpty
                    ? selectedAddress
                    : 'Your delivery address goes here',
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
  final List<String> addresses = [
    '123 Main Street',
    '456 Elm Avenue',
    '789 Pine Road',
    '1011 Maple Lane',
    '1213 Oak Drive'
  ];

  String? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Address Selection',
          style: TextStyle(color: Colors.deepOrange),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, selectedAddress);
          },
        ),
      ),
      body: Column(
        children: [
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
