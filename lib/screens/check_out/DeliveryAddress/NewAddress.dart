import 'package:ecommerce/models/Address.dart';
import 'package:ecommerce/models/AdministrativeUnit.dart';
import 'package:flutter/material.dart';
import 'LocationSelection.dart';

class NewAddress extends StatefulWidget {
  final String userId;

  const NewAddress({super.key, required this.userId});
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final _formKey = GlobalKey<FormState>();
  bool isDefault = false;
  String selectedLocation = '';
  late TextEditingController _receiverController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressLineController;
  late Future<List<AdministrativeUnit>>
      administrativeUnitsFuture; // Declare a future variable

  @override
  void initState() {
    super.initState();
    _receiverController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressLineController = TextEditingController();
    administrativeUnitsFuture =
        loadAdministrativeUnits(); // Assign the future to the variable
  }
  @override
  void dispose() {
    _receiverController.dispose();
    _phoneNumberController.dispose();
    _addressLineController.dispose();
    super.dispose();
  }
  void _addNewAddress() async {
  if (_formKey.currentState!.validate()) {
    // Tạo một đối tượng Address từ dữ liệu nhập vào
    final newAddress = Address(
      userId: widget.userId,
      receiver: _receiverController.text,
      phoneNumber: _phoneNumberController.text,
      addressLine: _addressLineController.text,
    );
    
    try {
      // Lưu địa chỉ mới vào cơ sở dữ liệu
      await newAddress.save();
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New address added successfully')),
      );
      
      // Quay lại màn hình trước đó
      Navigator.pop(context);
    } catch (error) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add new address')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Address',
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _receiverController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  // Use shape to create a rectangular border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  // Use shape to create a rectangular border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Address section
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              FutureBuilder<List<AdministrativeUnit>>(
                future: administrativeUnitsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading data'));
                  } else {
                    final administrativeUnits = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationSelection(
                              onLocationSelected: (location) {
                                setState(() {
                                  selectedLocation = location;
                                });
                              },
                              administrativeUnits: administrativeUnits,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedLocation.isNotEmpty
                                      ? selectedLocation
                                      : 'City, District, Ward',
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _addressLineController,
                decoration: InputDecoration(
                  labelText: 'Street Name, Building, House No.',
                  // Use shape to create a rectangular border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street name, building, and house number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Setting section
              Text(
                'Setting',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Label As'),
              SwitchListTile(
                title: Text('Set as default address'),
                value: isDefault,
                onChanged: (value) {
                  setState(() {
                    isDefault = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _addNewAddress();
          }
        },
        label: Text('Submit'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
