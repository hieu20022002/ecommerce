import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdministrativeUnit {
  final String id;
  final String name;
  final String type;
  final List<AdministrativeUnit>? subUnits;

  AdministrativeUnit({
    required this.id,
    required this.name,
    required this.type,
    this.subUnits,
  });
}

Future<List<AdministrativeUnit>> loadAdministrativeUnits() async {
  final jsonData = await rootBundle.loadString('assets/data/dvhcvn.json');
  final data = json.decode(jsonData);

  return List<AdministrativeUnit>.from(data['data'].map((unit) {
    final id = unit['level1_id'] as String;
    final name = unit['name'] as String;
    final type = unit['type'] as String;
    final subUnits = List<AdministrativeUnit>.from(
      unit['level2s'].map((subUnit) {
        final subUnitId = subUnit['level2_id'] as String;
        final subUnitName = subUnit['name'] as String;
        final subUnitType = subUnit['type'] as String;
        final subSubUnits = List<AdministrativeUnit>.from(
          subUnit['level3s'].map((subSubUnit) {
            final subSubUnitId = subSubUnit['level3_id'] as String;
            final subSubUnitName = subSubUnit['name'] as String;
            final subSubUnitType = subSubUnit['type'] as String;
            return AdministrativeUnit(
              id: subSubUnitId,
              name: subSubUnitName,
              type: subSubUnitType,
            );
          }),
        );
        return AdministrativeUnit(
          id: subUnitId,
          name: subUnitName,
          type: subUnitType,
          subUnits: subSubUnits,
        );
      }),
    );

    return AdministrativeUnit(
      id: id,
      name: name,
      type: type,
      subUnits: subUnits,
    );
  }));
}
