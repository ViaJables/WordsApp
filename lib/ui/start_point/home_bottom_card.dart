import 'dart:ui';

import 'package:flutter/material.dart';

class HomeBottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 95.0,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          border: Border.all(color: Colors.black26, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(37, 38, 65, 0.7),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2)],
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset('assets/clock_icon.png'),
                ),
              ),
              Expanded(
                child:
                  Column(
                    children: [
                      Text(
                        "Daily Gift: Free Bomb",
                        style: TextStyle(
                          fontSize:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.04,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, top: 12.5, bottom: 0),
                          child:
                          Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(37, 38, 65, 0.7),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ],
                            border: Border.all(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(30)),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Watch ad to claim",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
