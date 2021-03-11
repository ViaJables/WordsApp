import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/ui/common_widgets/auth_text_field.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool changed = false;
  TextEditingController name = new TextEditingController();
  String imgurl = null;
  File imageFile;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.045,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).accentColor);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'profile'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  GestureDetector(
                    onTap: () async {
                      selecttype(context, "Select any option");
                      setState(() {
                        changed = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Click on Image to Change',style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: MediaQuery.of(context).size.width * 0.05),),
                        SizedBox(height: 10,),
                        CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.1,
                            backgroundImage:
                                imgurl != null ? NetworkImage(imgurl) : null,
                            child: imgurl == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.height * 0.1,
                                  )
                                : Container()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          changed = true;
                        });
                      },
                      child: AuthTextField(title: 'Username', controller: name),
                    ),
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    onPressed: () async {
                      await addData();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (_) => WalkTroughPage()),
                      //         (route) => false);
                    },
                    child: Text(changed == false ? '' : 'SAVE', style: style),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> readData() async {
    print(Constants.useruid.toString());
    Firestore.instance
      ..collection('users')
          .document(Constants.useruid)
          .get()
          .then((querySnapshot) {
        print(querySnapshot.data);
        imgurl = querySnapshot.data['image'];
        name.text = querySnapshot.data['UserName'];
        setState(() {});
      });
  }

  uploadimage(File filepath) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    final uploadTask = storageReference.putFile(filepath);
    var taskSnapshot = await uploadTask.onComplete;
    imgurl = await storageReference.getDownloadURL();
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
    await uploadimage(_image);
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
    if (imgurl != null) {
      print("adding img");
      await Firestore.instance
          .collection('users')
          .document(Constants.useruid)
          .updateData({'image': imgurl});
    }
    if (name.text != '') {
      print("adding name");
      await Firestore.instance
          .collection('users')
          .document(Constants.useruid)
          .updateData({'UserName': name.text});
      print("imageadded");
      // AuthHelper helper = AuthHelper();
      // var result =
      // await helper.username(context,username.text);
    }
    dialog.hide();
  }
}
