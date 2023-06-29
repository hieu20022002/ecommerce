import 'package:ecommerce/controller/AddressController.dart';
import 'package:ecommerce/models/Address.dart';
import 'package:flutter/material.dart';

import 'NewAddress.dart';

class DeliveryAddress extends StatefulWidget {
  final Address selectedAddress;
  final String userId;
  final Function(Address) onAddressSelected; 
  DeliveryAddress({required this.selectedAddress, required this.userId,  required this.onAddressSelected});

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  Address selectedAddress = Address();
  late String addressId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressSelection(userId: widget.userId)),
        );
        if (selected != null) {
          setState(() {
            addressId = selected;
          });
          selectedAddress = await Address.getById(addressId);
          widget.onAddressSelected(selectedAddress);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAddress.receiver ?? 'Receiver Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    selectedAddress.phoneNumber ?? 'Phone Number',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    selectedAddress.addressLine ?? 'Address Line',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressSelection extends StatefulWidget {
  final String userId;

  const AddressSelection({Key? key, required this.userId}) : super(key: key);

  @override
  _AddressSelectionState createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  List<Address> addresses = [];
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  void _getAddress() async {
    addresses = await AddressController.AddressByUserId(widget.userId);
    setState(() {
      selectedAddress = addresses.isNotEmpty ? addresses[0].id : null;
    });
  }

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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addresses[index].receiver ?? 'Receiver Name'),
                      SizedBox(height: 5),
                      Text(addresses[index].phoneNumber ?? 'Phone Number'),
                      SizedBox(height: 5),
                      Text(addresses[index].addressLine ?? 'Address Line'),
                    ],
                  ),
                  value: addresses[index].id ?? '',
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
                MaterialPageRoute(builder: (context) => NewAddress(userId: widget.userId)),
              );
            },
          )
        ],
      ),
    );
  }
}
