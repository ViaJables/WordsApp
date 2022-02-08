import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/res/static_info.dart';
import 'package:synonym_app/ui/admin/admin_home.dart';
import 'package:synonym_app/ui/admin/admin_info.dart';
import 'package:synonym_app/ui/common_widgets/auth_text_field.dart';
import 'package:synonym_app/ui/shared/starfield.dart';
import 'package:synonym_app/ui/start_point/home.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailCon = TextEditingController();
  TextEditingController _passwordCon = TextEditingController();

  bool pleaseWait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Starfield(),
          Column(
            children: <Widget>[
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).padding.top +
                            MediaQuery.of(context).padding.bottom),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: <Widget>[
                            AuthTextField(
                                title: 'Email', controller: _emailCon),
                            SizedBox(height: 30),
                            AuthTextField(
                              title: 'Password',
                              controller: _passwordCon,
                              obscure: true,
                            ),
                            SizedBox(height: 45),
                            GestureDetector(
                              onTap: () {
                                _login();
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26, blurRadius: 5)
                                  ],
                                  border: Border.all(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 25),
                                    ),
                                  ],
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
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(bool isGoodNews) {
    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      content: isGoodNews
          ? Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 25,
                  ),
                  Text(
                    "Logging in",
                    textScaleFactor: 1.75,
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  _saveUser(LocalUser user) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString(Keys.user, json.encode(user.toMap()));
    print("LOGGED IN AND SAVED USER");
  }



  fbAuth(String email, String name, String id, String token) async {
    // ProgressDialog dialog = ProgressDialog(context);
    // dialog.style(
    //   message: 'Please wait...',
    //   progressWidget: CircularProgressIndicator(),
    // );
    try {
      final facebookAuthCred = FacebookAuthProvider.credential(token);
      final fbUser =
          await FirebaseAuth.instance.signInWithCredential(facebookAuthCred);
      String fbUid = fbUser.user!.uid;

      await http.get(Uri.https(
          'jsonplaceholder.typicode.com',
          'http://graph.facebook.com/v9.0/$id/picture?access_token=$token'));
      //Uint8List fbImage = response.bodyBytes.buffer.asUint8List();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      String imgUrlLink = await storageReference.getDownloadURL();
      String userName = name.replaceAll(' ', '');
      LocalUser user = LocalUser(
        uid: fbUid,
        name: name,
        email: email,
        image: imgUrlLink,
        userName: userName,
      );
      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(fbUid)
          .set(user.toMap());

      await _saveUser(user);

      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;
      print('All Done');
      //dialog.hide();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Home()), (route) => false);
    } catch (e) {
      if (e.toString() ==
          'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
        print("user is already login");
      } else {
        // Navigator.pop(context);
        // showSnackBar("Error login with Facebook");
        print('It didn\'t worked');
      }
    }
  }

  // ------------------- Facebook Login End ------------------ //

  // ------------------- Google Login Start ------------------ //
  signInWithGoogle() async {
    // ProgressDialog dialog = ProgressDialog(context);
    // dialog.style(
    //   message: 'Please wait...',
    //   progressWidget: CircularProgressIndicator(),
    // );
    // dialog.show();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('1');

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('2');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('3');
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      List<String> bigPic = authResult.user!.photoURL!.split('=');
      await http.get(
        Uri.https('jsonplaceholder.typicode.com', '${bigPic[0]}'),
      );
      String imageName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      //Uint8List googleImage = response.bodyBytes.buffer.asUint8List();
      var storageReference = FirebaseStorage.instance.ref().child(imageName);
      //final uploadTask = storageReference.putData(googleImage);
      String imgUrlLink = await storageReference.getDownloadURL();
      String userName = authResult.user!.displayName!.replaceAll(' ', '');
      String userUid = authResult.user!.uid;
      LocalUser user = LocalUser(
        uid: userUid,
        name: authResult.user!.displayName ?? "",
        email: authResult.user!.email ?? "",
        image: imgUrlLink,
        userName: userName,
      );
      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(userUid)
          .set(user.toMap());

      await _saveUser(user);

      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;
      print('All Done');
      //dialog.hide();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Home()), (route) => false);
    } catch (e) {
      print(e);
      if (e.toString().contains('was called on null')) {
        print('Cancelled');
        //dialog.hide();
      }
    }
  }

  // ------------------- Google Login End ------------------ //

  // ------------------- Apple Login Start ------------------ //
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    // ProgressDialog dialog = ProgressDialog(context);
    // dialog.style(
    //   message: 'Please wait...',
    //   progressWidget: CircularProgressIndicator(),
    // );
    // dialog.show();
    // Request credential for the currently signed in Apple account.
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      String userUid = authResult.user!.uid;
      String name =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      String userName = name.replaceAll(' ', '');
      String email = appleCredential.email ?? "";

      LocalUser user = LocalUser(
        uid: userUid,
        name: name,
        email: email,
        image: 'None Because Apple',
        userName: userName,
      );
      await FirebaseFirestore.instance
          .collection(Keys.user)
          .doc(userUid)
          .set(user.toMap());

      await _saveUser(user);

      Provider.of<LocalUser>(context, listen: false).uid = user.uid;
      Provider.of<LocalUser>(context, listen: false).name = user.name;
      Provider.of<LocalUser>(context, listen: false).email = user.email;
      Provider.of<LocalUser>(context, listen: false).image = user.image;
      print('All Done');
      //dialog.hide();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Home()), (route) => false);
    } catch (e) {
      if (e.toString().contains('canceled')) {
        //dialog.hide();
      }
    }
  }

  // ------------------- Apple Login End ------------------ //

  _login() async {
    String email = _emailCon.text.trim().toLowerCase();
    String password = _passwordCon.text;

    FocusScope.of(context).requestFocus(FocusNode());

    if (email.isEmpty || password.isEmpty) {
      StaticInfo.showToast(context, 'enter email and password', duration: 2);
      return;
    }

    // ProgressDialog dialog = ProgressDialog(context);
    // dialog.style(
    //   message: 'Please wait...',
    //   progressWidget: CircularProgressIndicator(),
    // );
    // dialog.show();

    if (email == 'admin') {
      email += '@admin.com';
    }

    AuthHelper helper = AuthHelper();
    String result = await helper.login(context, email, password);

    //dialog.hide();

    if (result == null) {
      var page;

      if (email == adminEmail)
        page = AdminHome();
      else {
        page = Home();
      }

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => page), (_) => false);
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      if (result == 'ERROR_INVALID_EMAIL')
        StaticInfo.showToast(context, 'invalid email', duration: 5);
      else if (result == 'ERROR_USER_NOT_FOUND')
        StaticInfo.showToast(context, 'no user found with this email',
            duration: 5);
      else if (result == 'ERROR_WRONG_PASSWORD')
        StaticInfo.showToast(context, 'wrong password', duration: 5);
      else
        StaticInfo.showToast(context, 'some error has occured while signing in',
            duration: 5);
      print(result);
    }
  }
}
