import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String title;
  final bool obscure;
  final TextEditingController controller;

  AuthTextField({
    @required this.title,
    @required this.controller,
    this.obscure = false,
  });

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool obscure;

  @override
  void initState() {
    super.initState();

    obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
        SizedBox(height: 7.5),
        TextField(
          controller: widget.controller,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            suffixIcon: !widget.obscure
                ? null
                : IconButton(
                    icon:
                        Icon(obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
          ),
          obscureText: widget.obscure ? obscure : widget.obscure,
        ),
      ],
    );
  }
}
