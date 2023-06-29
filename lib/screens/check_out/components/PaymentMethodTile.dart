import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const PaymentMethodTile({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
