import 'package:flutter/material.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Store extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            new Starfield(),
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Store',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 60),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            purchaseBombs(context);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                            Text(
                              "5 Bombs",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20),
                            ),
                                Spacer(),
                                Text(
                                  "\$0.99",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),

                            ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            purchaseClocks(context);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  "5 Clocks",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  "\$0.99",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            purchaseHourglasses(context);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  "5 Hourglasses",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  "\$0.99",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        BouncingWidget(
                          duration: Duration(milliseconds: 30),
                          scaleFactor: 1.5,
                          onPressed: () {
                            purchaseHearts(context);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(37, 38, 65, 0.7),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  "10 Lives",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  "\$0.99",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> purchaseHearts(BuildContext context) async {
    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'lives': user.lives + 10});


    return "done";
  }

  Future<String> purchaseBombs(BuildContext context) async {
    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'bombs': user.lives + 5});


    return "done";
  }

  Future<String> purchaseClocks(BuildContext context) async {
    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'clocks': user.clocks + 5});


    return "done";
  }

  Future<String> purchaseHourglasses(BuildContext context) async {
    var user = await _getUser();

    await FirebaseFirestore.instance
        .collection(Keys.user)
        .doc(user.uid)
        .update({'hourglasses': user.hourglasses + 5});


    return "done";
  }

  Future<LocalUser> _getUser() async {

      LocalUser user = LocalUser.fromMap((await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get())
          .data()!);
      return user;
  }
}
