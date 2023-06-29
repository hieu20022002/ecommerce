import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Transform(
                transform: Matrix4.skewX(-0.2),
                child: Container(
                  width: 40,
                  color: index % 2 == 0 ? Colors.blue : Colors.red,
                ),
              ),
              SizedBox(width: 5),
            ],
          );
        },
      ),
    );
  }
}