import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
