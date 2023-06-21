import 'package:flutter/material.dart';

class LocationSelection extends StatelessWidget {
  final Function(String) onLocationSelected;

  LocationSelection({required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Location Selection',
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('City 1'),
            onTap: () => onLocationSelected('City 1'),
          ),
          ListTile(
            title: Text('City 2'),
            onTap: () => onLocationSelected('City 2'),
          ),
          ListTile(
            title: Text('City 3'),
            onTap: () => onLocationSelected('City 3'),
          ),
          // Add more cities, districts, and wards as needed
        ],
      ),
    );
  }
}
