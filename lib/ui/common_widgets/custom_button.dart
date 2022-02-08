import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function()? onTap;

  CustomButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      padding: EdgeInsets.symmetric(vertical: 10),
      minWidth: double.infinity,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize:
          MediaQuery
              .of(context)
              .size
              .width * 0.055,
        ),
      ),
    );
  }

}
