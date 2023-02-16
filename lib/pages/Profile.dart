import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_language_firebase_chat_app/main.dart';
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';
import 'package:multi_language_firebase_chat_app/pages/SignIn.dart';

import '../models/UIHelper.dart';
import 'LoginPage.dart';

//import 'package:flutter_ui_challenges/core/presentation/res/assets.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  // final User firebaseUser;
  final UserModel userModel;

  const Profile({required this.userModel});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;
  void selectImage(ImageSource source) async {
    log("selectImage");
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
      uplodeData();
    }
  }

  // void checkValues() {
  //   //String fullname = fullNameController.text.trim();

  //   if (imageFile == null) {
  //     UIHelper.showAlertDialog(context, "Incomplete Data",
  //         "Please fill all the field and uplode a profile picture");
  //   } else {
  //     uplodeData();
  //   }
  // }

  void uplodeData() async {
    //UIHelper.showLoadingDialog(context, "Uploding image....");

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(uuid.v1())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();

    //String? fullname = fullNameController.text.trim();

    // widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return HomePage(
      //         userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      //   }),
      // );
    });
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Uplode Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album_rounded),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a Photo"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _itemHeader = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16.0,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "my profile",
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  //avatar
                  Ink(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.userModel.profilepic.toString()),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.5, 1.5),
                    child: MaterialButton(
                      minWidth: 0,
                      child: Icon(Icons.camera_alt),
                      onPressed: () {
                        showPhotoOption();
                      },
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
            ),
          ),
          // ListTile(
          //   title: Text(
          //     "notifications",
          //     style: _itemHeader,
          //   ),
          //   leading: Icon(Icons.notifications),
          // ),
          // SwitchListTile(
          //   value: true,
          //   title: Text("email notifications"),
          //   onChanged: (value) {},
          //   secondary: SizedBox(
          //     width: 10,
          //   ),
          // ),
          // SwitchListTile(
          //   value: false,
          //   title: Text("push notifications"),
          //   onChanged: (value) {},
          //   secondary: SizedBox(
          //     width: 10,
          //   ),
          // ),
          // _buildDivider(),
          // ListTile(
          //   title: Text(
          //     "privacy",
          //     style: _itemHeader,
          //   ),
          //   leading: Icon(Icons.person),
          // ),
          // RadioListTile(
          //   value: true,
          //   groupValue: true,
          //   title: Text("private"),
          //   onChanged: (dynamic value) {},
          //   secondary: SizedBox(
          //     width: 10,
          //   ),
          //   controlAffinity: ListTileControlAffinity.trailing,
          // ),
          // RadioListTile(
          //   value: false,
          //   groupValue: true,
          //   controlAffinity: ListTileControlAffinity.trailing,
          //   title: Text("public"),
          //   onChanged: (dynamic value) {},
          //   secondary: SizedBox(
          //     width: 10,
          //   ),
          // ),
          // _buildDivider(),
          ListTile(
            title: Text("feedback"),
            subtitle: Text("we would love to hear your experience"),
            leading: Icon(Icons.feedback),
          ),
          ListTile(
            title: Text("terms and conditions"),
            subtitle: Text("legal, terms and conditions"),
            leading: Icon(Icons.feedback),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return SignInPage();
                },
              ));
            },
            title: Text("logout"),
            subtitle: Text("you can logout from here"),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        color: Colors.black,
      ),
    );
  }
}
