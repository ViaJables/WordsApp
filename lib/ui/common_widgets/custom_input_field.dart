import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  CustomInputField(this.hint, this.controller, [this.obscure = false]);

  var _inputBorder;

  @override
  Widget build(BuildContext context) {
    _inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
      ),
    );

    return Container(
      color: Color(0xffF6F6F1),
      child: TextField(
        cursorColor: Theme.of(context).secondaryHeaderColor,
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: _inputBorder,
          enabledBorder: _inputBorder,
          focusedBorder: _inputBorder,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
