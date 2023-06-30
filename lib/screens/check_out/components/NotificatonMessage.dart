import 'package:flutter/material.dart';

class NotificationMessage extends StatelessWidget {
  final String message;
  const NotificationMessage({required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 240, 132, 100),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}