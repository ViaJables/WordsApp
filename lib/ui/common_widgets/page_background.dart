import 'package:flutter/material.dart';
import 'package:synonym_app/ui/common_widgets/banner-ad_box.dart';

class PageBackground extends StatelessWidget {
  final GlobalKey scaffoldKey;

  final String title, subtitle;
  final Color appBarColor;
  final Widget child, trailing, leading;
  final Function trailingTap, leadingTap;

  PageBackground({
    @required this.title,
    @required this.appBarColor,
    @required this.child,
    this.scaffoldKey,
    this.subtitle,
    this.leading,
    this.trailing,
    this.trailingTap,
    this.leadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: leading == null ? Container() : leading,
                        iconSize: 50,
                        onPressed: leadingTap,
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text(
                              title.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27),
                            ),
                            subtitle == null
                                ? Container()
                                : Text(
                                    subtitle.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: trailing == null ? Container() : trailing,
                        iconSize: 50,
                        color: Colors.black,
                        onPressed: trailingTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: <Widget>[Expanded(child: child), BannerAdBox()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
