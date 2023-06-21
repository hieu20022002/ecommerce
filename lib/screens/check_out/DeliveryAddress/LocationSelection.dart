import 'package:flutter/material.dart';
import 'package:ecommerce/models/AdministrativeUnit.dart';

class LocationSelection extends StatefulWidget {
  final List<AdministrativeUnit> administrativeUnits;
  final Function(String) onLocationSelected;

  LocationSelection({
    required this.administrativeUnits,
    required this.onLocationSelected,
  });

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  int level = 1;
  String selectedProvince = '';
  String selectedDistrict = '';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<AdministrativeUnit> units = widget.administrativeUnits;
    if (level == 2) {
      units =
          units.firstWhere((unit) => unit.name == selectedProvince).subUnits!;
    } else if (level == 3) {
      units = units
          .firstWhere((unit) => unit.name == selectedProvince)
          .subUnits!
          .firstWhere((unit) => unit.name == selectedDistrict)
          .subUnits!;
    }

    if (searchQuery.isNotEmpty) {
      units = units
          .where((unit) =>
              unit.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 9,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          final administrativeUnit = units[index];

          return ListTile(
            title: Text(administrativeUnit.name),
            onTap: () {
              if (level == 1) {
                setState(() {
                  level = 2;
                  selectedProvince = administrativeUnit.name;
                });
              } else if (level == 2) {
                setState(() {
                  level = 3;
                  selectedDistrict = administrativeUnit.name;
                });
              } else if (level == 3) {
                widget.onLocationSelected(
                    '$selectedProvince\n$selectedDistrict\n${administrativeUnit.name}');
              }
            },
          );
        },
      ),
    );
  }
}
