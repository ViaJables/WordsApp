import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synonym_app/models/localuser.dart';
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
          Provider.of<LocalUser>(context, listen: false).uid = user.uid;
          Provider.of<LocalUser>(context, listen: false).name = user.name;
          Provider.of<LocalUser>(context, listen: false).email = user.email;
          Provider.of<LocalUser>(context, listen: false).image = user.image;
        }

        return 'done';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(
      BuildContext context, LocalUser user, String password) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: password);
      if (result.user == null) return 'error';
      user.uid = result.user!.uid;
      Constants.useruid = result.user!.uid;
      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(user.uid)
          .set(user.toMap());
      await _saveUser(user);
      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;
      return 'done';
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> updatePic(
      BuildContext context, String image, String username) async {
    try {
//      var fUser = await FirebaseAuth.instance.currentUser();
//      if (fUser == null) return false;

      LocalUser user = LocalUser(
        uid: Provider.of<LocalUser>(context).uid,
        name: Provider.of<LocalUser>(context).name,
        email: Provider.of<LocalUser>(context).email,
        userName: Provider.of<LocalUser>(context).userName,
        image: image,
        // UserName:username
      );

      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(user.uid)
          .update(user.toMap());

      await _saveUser(user);
      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;

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

      LocalUser user = LocalUser(
          uid: Provider.of<LocalUser>(context).uid,
          name: Provider.of<LocalUser>(context).name,
          email: Provider.of<LocalUser>(context).email,
        userName: Provider.of<LocalUser>(context).userName
      );

      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(user.uid)
          .update(user.toMap());

      await _saveUser(user);
      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;

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

  Future<LocalUser?> getCurrentUser(BuildContext context) async {
    try {
      var fUser = FirebaseAuth.instance.currentUser;
      if (fUser == null) return null;
      Constants.useruid = fUser.uid.toString();
      print(Constants.useruid);
      LocalUser currentUser;
      var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);
      if (prefResult == null) {
        currentUser = LocalUser.fromMap((await FirebaseFirestore.instance
                .collection(Keys.user)
                .doc(fUser.uid)
                .get())
            .data()!);
        _saveUser(currentUser);
      } else
        currentUser = LocalUser.fromMap(json.decode(prefResult as String));

      Provider.of<LocalUser>(context, listen: false).uid = currentUser.uid;
      Provider.of<LocalUser>(context, listen: false).name = currentUser.name;
      Provider.of<LocalUser>(context, listen: false).email = currentUser.email;
      Provider.of<LocalUser>(context, listen: false).image = currentUser.image;

      return currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<LocalUser?> getRemoteUser(BuildContext context) async {
    try {
      var fUser = FirebaseAuth.instance.currentUser;
      if (fUser == null) return null;
      Constants.useruid = fUser.uid.toString();
      print(Constants.useruid);
      LocalUser currentUser;

      currentUser = LocalUser.fromMap((await FirebaseFirestore.instance
            .collection(Keys.user)
            .doc(fUser.uid)
            .get())
            .data()!);
      _saveUser(currentUser);
      Provider.of<LocalUser>(context, listen: false).uid = currentUser.uid;
      Provider.of<LocalUser>(context, listen: false).name = currentUser.name;
      Provider.of<LocalUser>(context, listen: false).email = currentUser.email;
      Provider.of<LocalUser>(context, listen: false).image = currentUser.image;

      return currentUser;
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    (await SharedPreferences.getInstance()).remove(Keys.user);
  }

  _saveUser(LocalUser user) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString(Keys.user, json.encode(user.toMap()));
  }

  Future<LocalUser> _getUser() async {
    var prefResult = (await SharedPreferences.getInstance()).get(Keys.user);
    if (prefResult == null) {
      LocalUser user = LocalUser.fromMap((await FirebaseFirestore.instance
              .collection(Keys.user)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get())
          .data()!);
      _saveUser(user);
      return user;
    } else
      return LocalUser.fromMap(json.decode(prefResult as String));
  }
}
