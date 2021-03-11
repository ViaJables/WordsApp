import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/admin/admin_info.dart';

class AuthHelper {
  Future<String> login(
      BuildContext context, String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user == null)
        return 'error';
      else {
        if (email != adminEmail) {
          var user = await _getUser();
          Constants.useruid = user.uid.toString();
          Provider.of<User>(context, listen: false).uid = user.uid;
          Provider.of<User>(context, listen: false).name = user.name;
          Provider.of<User>(context, listen: false).email = user.email;
          Provider.of<User>(context, listen: false).image = user.image;
        }

        return null;
      }
    } catch (e) {
      return e.code;
    }
  }

  Future<String> signUp(
      BuildContext context, User user, String password) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: password);
      if (result.user == null) return 'error';
      user.uid = result.user.uid;
      Constants.useruid = result.user.uid;
      await Firestore.instance
          .collection(Keys.user)
          .document(user.uid)
          .setData(user.toMap());
      await _saveUser(user);
      Provider.of<User>(context, listen: false).uid = user.uid;
      Provider.of<User>(context, listen: false).name = user.name;
      Provider.of<User>(context, listen: false).email = user.email;
      Provider.of<User>(context, listen: false).image = user.image;
      return null;
    } catch (e) {
      return e.code;
    }
  }

  Future<bool> updatePic(
      BuildContext context, String image, String username) async {
    try {
//      var fUser = await FirebaseAuth.instance.currentUser();
//      if (fUser == null) return false;

      User user = User(
        uid: Provider.of<User>(context).uid,
        name: Provider.of<User>(context).name,
        email: Provider.of<User>(context).email,
        image: image,
        // UserName:username
      );

      await Firestore.instance
          .collection(Keys.user)
          .document(user.uid)
          .updateData(user.toMap());

      await _saveUser(user);
      Provider.of<User>(context, listen: false).uid = user.uid;
      Provider.of<User>(context, listen: false).name = user.name;
      Provider.of<User>(context, listen: false).email = user.email;
      Provider.of<User>(context, listen: false).image = user.image;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> username(BuildContext context, String username) async {
    try {
//      var fUser = await FirebaseAuth.instance.currentUser();
//      if (fUser == null) return false;

      User user = User(
          uid: Provider.of<User>(context).uid,
          name: Provider.of<User>(context).name,
          email: Provider.of<User>(context).email);

      await Firestore.instance
          .collection(Keys.user)
          .document(user.uid)
          .updateData(user.toMap());

      await _saveUser(user);
      Provider.of<User>(context, listen: false).uid = user.uid;
      Provider.of<User>(context, listen: false).name = user.name;
      Provider.of<User>(context, listen: false).email = user.email;
      Provider.of<User>(context, listen: false).image = user.image;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User> getCurrentUser(BuildContext context) async {
    try {
      var fUser = await FirebaseAuth.instance.currentUser();
      if (fUser == null) return null;
      Constants.useruid = fUser.uid.toString();
      print(Constants.useruid);
      User currentUser;
      var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);
      if (prefResult == null) {
        currentUser = User.fromMap((await Firestore.instance
                .collection(Keys.user)
                .document((await FirebaseAuth.instance.currentUser()).uid)
                .get())
            .data);
        _saveUser(currentUser);
      } else
        currentUser = User.fromMap(json.decode(prefResult));

      Provider.of<User>(context, listen: false).uid = currentUser.uid;
      Provider.of<User>(context, listen: false).name = currentUser.name;
      Provider.of<User>(context, listen: false).email = currentUser.email;
      Provider.of<User>(context, listen: false).image = currentUser.image;

      return currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    (await SharedPreferences.getInstance()).remove(Keys.user);
  }

  _saveUser(User user) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString(Keys.user, json.encode(user.toMap()));
  }

  Future<User> _getUser() async {
    var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);
    if (prefResult == null) {
      User user = User.fromMap((await Firestore.instance
              .collection(Keys.user)
              .document((await FirebaseAuth.instance.currentUser()).uid)
              .get())
          .data);
      _saveUser(user);
      return user;
    } else
      return User.fromMap(json.decode(prefResult));
  }
}
