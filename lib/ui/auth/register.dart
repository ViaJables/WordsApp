import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/res/static_info.dart';
import 'package:synonym_app/ui/common_widgets/auth_text_field.dart';
import 'package:synonym_app/ui/common_widgets/custom_button.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/start_point/walk_trough_page.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _userNameCon = TextEditingController();
  TextEditingController _passwordCon = TextEditingController();
  TextEditingController _confirmCon = TextEditingController();

  bool termsAndConditionsFlag = false;
  bool saleDataFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HelpIcon(),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).padding.top +
                            MediaQuery.of(context).padding.bottom),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
//                      AuthTextField(title: 'Email', controller: _emailCon),
//                      SizedBox(height: 10),
                            AuthTextField(
                                title: 'Enter a Username',
                                controller: _userNameCon),
                            SizedBox(height: 10),
                            AuthTextField(
                              title: 'Create a password',
                              controller: _passwordCon,
                              obscure: true,
                            ),
                            SizedBox(height: 10),
                            AuthTextField(
                              title: 'Repeat password',
                              controller: _confirmCon,
                              obscure: true,
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              leading: Checkbox(
                                value: termsAndConditionsFlag,
                                onChanged: (val) {
                                  setState(() {
                                    termsAndConditionsFlag = val;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  termsAndConditionsFlag =
                                      !termsAndConditionsFlag;
                                });
                              },
                              title: Text(
                                  'I have read and agree to the terms of use and the privacy policies of Synonym Antonym'),
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              leading: Checkbox(
                                value: saleDataFlag,
                                onChanged: (val) {
                                  setState(() {
                                    saleDataFlag = val;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  saleDataFlag = !saleDataFlag;
                                });
                              },
                              title: Text(
                                'I acknowledge that this app will not sale my data to third party',
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: CustomButton(
                                text: 'CREATE ACCOUNT',
                                color: Theme.of(context).primaryColor,
                                onTap: _register,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _register() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String userName = _userNameCon.text.trim().toLowerCase();
    String email = '$userName@synonym.com';
    String password = _passwordCon.text;
    String confirm = _confirmCon.text;

    if (password.isEmpty || userName.isEmpty || confirm.isEmpty) {
      StaticInfo.showToast(context, 'fill all fields', duration: 2);
      return;
    } else if (password.length < 6) {
      StaticInfo.showToast(
          context, 'password must be at least 6 characters long',
          duration: 2);
      return;
    } else if (password != confirm) {
      StaticInfo.showToast(context, 'password does not match', duration: 2);
      return;
    } else if (!termsAndConditionsFlag) {
      StaticInfo.showToast(context, 'Accept terms and conditions', duration: 2);
      return;
    }

    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      message: 'Please wait...',
      progressWidget: CircularProgressIndicator(),
    );
    dialog.show();

    User user = User(
      uid: null,
      userName: userName,
      email: email,
      image: null,
    );

    AuthHelper helper = AuthHelper();
    String result = await helper.signUp(context, user, password);
    dialog.hide();

    if (result == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => AddProfilePage()));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) => WalkTroughPage()));
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      if (result == 'ERROR_INVALID_EMAIL')
        StaticInfo.showToast(context, 'invalid email', duration: 5);
      else if (result == 'ERROR_EMAIL_ALREADY_IN_USE')
        StaticInfo.showToast(context, 'user already exist', duration: 5);
      else
        StaticInfo.showToast(context, 'some error has occured while signing up',
            duration: 5);
    }
  }
}

class AddProfilePage extends StatefulWidget {
  AddProfilePage({Key key}) : super(key: key);

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  TextEditingController name = new TextEditingController();
  File imageFile;
  File _image;
  final picker = ImagePicker();
  String image = null;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.045,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).accentColor);
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              selecttype(context, "Select Option");
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.height / 3,
              decoration: image == null
                  ? BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.7)),
                    )
                  : BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.7)),
                      image: DecorationImage(image: NetworkImage(image))),
              child: Center(child: Text(image == null ? "ADD IMAGE" : '')),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child:
                AuthTextField(title: 'Enter Your Full Name', controller: name),
          ),
          SizedBox(height: 10),
          FlatButton(
            onPressed: () async {
              await addData();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => WalkTroughPage()),
                  (route) => false);
            },
            child: image != null && name.text != '' ? Text('SAVE', style: style) : Container(),
          ),
        ],
      ),
    ));
  }

  uploadImage(File filepath) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final uploadTask = storageReference.putFile(filepath);
    var taskSnapshot = await uploadTask.onComplete;
    image = await storageReference.getDownloadURL();
    setState(() {});
  }

  Future _cropImage(File imageFile) async {
    var croppedFile = await ImageCropper.cropImage(
        compressQuality: 30,
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'CROP',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'CROP',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
    await uploadImage(_image);
  }

  selecttype(BuildContext context, String str) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(str),
            content: Container(
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  butt(() {
                    getImage();
                    Navigator.pop(context);
                  }, "Camera"),
                  butt(() {
                    getgalleryimg();
                    Navigator.pop(context);
                  }, "Gallery")
                ],
              ),
            ),
          );
        });
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      await _cropImage(File(pickedFile.path));
    } catch (e) {
      print(e.toString());
    }
  }

  Future getgalleryimg() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    await _cropImage(File(pickedFile.path));
  }

  Widget butt(Function ontap, String name) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black, width: 1)),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
          child: Text(
            name,
            style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45),
          ),
        ),
      ),
    );
  }

  Future<void> addData() async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      message: 'Please wait...',
      progressWidget: CircularProgressIndicator(),
    );
    dialog.show();
    if (image != null) {
      print("adding img");
      await Firestore.instance
          .collection('users')
          .document(Constants.useruid)
          .updateData({'image': image});
    }
    if (name.text != '') {
      print("adding name");
      await Firestore.instance
          .collection('users')
          .document(Constants.useruid)
          .updateData({'name': name.text});
      AuthHelper helper = AuthHelper();
      var result = await helper.username(context, name.text);
    }
    dialog.hide();
  }
}