import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double radius;
  final Widget image;


  ProfileImage(this.radius, this.image);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
     // child: image == null,
    );
  }
}
