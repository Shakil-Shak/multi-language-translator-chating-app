import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/HomePage.dart';
import 'package:multi_language_firebase_chat_app/pages/SignIn.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../main.dart';
import '../models/AnimatedButton.dart';
import '../models/UIHelper.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? profileImageFile, coverImageFile;
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  // TextEditingController firstNameController = TextEditingController();
  // TextEditingController lastNameController = TextEditingController();

  void selectImage(ImageSource source, String btn) async {
    log("selectImage");
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      log("cropImage");
      cropImage(pickedFile, btn);
    }
  }

  void cropImage(XFile file, String btn) async {
    log("cropedImage");
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: (btn == "p")
            ? CropAspectRatio(ratioX: 1, ratioY: 1)
            : CropAspectRatio(ratioX: 16, ratioY: 10),
        compressQuality: 20);

    if (croppedImage != null) {
      if (btn == "p") {
        setState(() {
          profileImageFile = File(croppedImage.path);
        });
      } else {
        setState(() {
          coverImageFile = File(croppedImage.path);
        });
      }
    }
  }

  void checkValues(RoundedLoadingButtonController btn) {
    // String fullname = firstNameController.text.trim();
    // String lastname = lastNameController.text.trim();

    if (profileImageFile == null || coverImageFile == null) {
      btn.error();
      UIHelper.showAlertDialogForSignIn(context, "Incomplete Data",
          "Please a profile and cover picture", btn);
    } else {
      uplodeData(btn);
    }
  }

  void uplodeData(RoundedLoadingButtonController btn) async {
    // UIHelper.showLoadingDialog(context, "Uploding image....");

    UploadTask uploadTaskP = FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("profilepictures")
        .child(uuid.v1())
        .putFile(profileImageFile!);

    TaskSnapshot snapshotP = await uploadTaskP;

    String? profileImageUrl = await snapshotP.ref.getDownloadURL();

    UploadTask uploadTaskC = FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("coverpictures")
        .child(uuid.v1())
        .putFile(coverImageFile!);

    TaskSnapshot snapshotC = await uploadTaskC;

    String? coverImageUrl = await snapshotC.ref.getDownloadURL();

    widget.userModel.profilepic = profileImageUrl;
    widget.userModel.coverPhoto = coverImageUrl;

    btn.success();

    log("Uplode data3");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data Uploded");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        }),
      );
    });
  }

  void showPhotoOption(String btn) {
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
                    selectImage(ImageSource.gallery, btn);
                  },
                  leading: Icon(Icons.photo_album_rounded),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera, btn);
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorsModel.orangeColors,
              colorsModel.orangeLightColors
            ], end: Alignment.centerLeft, begin: Alignment.centerRight),
          ),
        ),
        //backgroundColor: Colors.grey[800],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Complete Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return SignInPage();
                },
              ));
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/images/belgium.png',
              ),
              fit: BoxFit.contain,
              opacity: 0.1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
                child: Text(
              "Profile Picture",
              style: TextStyle(fontSize: 20),
            )),
            SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 10,
                ),
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: (profileImageFile != null)
                        ? FileImage(profileImageFile!)
                        : null,
                    child: (profileImageFile == null)
                        ? Image.asset(
                            "lib/images/profile.png",
                          )
                        : null,
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    showPhotoOption("p");
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: colorsModel.orangeColors,
                    child: (profileImageFile != null)
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 24.0,
                          )
                        : Icon(
                            // <-- Icon
                            Icons.upload,
                            color: Colors.white,
                            size: 24.0,
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Divider(),
            Center(
                child: Text(
              "Cover Photo",
              style: TextStyle(fontSize: 20),
            )),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(),
              child: (coverImageFile != null)
                  ? Image.file(
                      coverImageFile!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "lib/images/profile.png",
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(
              height: 25,
            ),
            FloatingActionButton.extended(
              label: (coverImageFile != null)
                  ? Text('Complete')
                  : Text('Uplode Cover Photo'), // <-- Text
              backgroundColor: colorsModel.orangeColors,
              icon: (coverImageFile != null)
                  ? Icon(
                      // <-- Icon
                      Icons.done,
                      size: 24.0,
                      color: Colors.white,
                    )
                  : Icon(
                      // <-- Icon
                      Icons.upload,
                      size: 24.0,
                      color: Colors.white,
                    ),
              onPressed: () {
                showPhotoOption("c");
              },
            ),
            // Text(imageFile.toString()),
            SizedBox(
              height: 25,
            ),
            // TextField(
            //   controller: firstNameController,
            //   decoration: InputDecoration(labelText: "Full Name"),
            // ),
            // TextField(
            //   controller: lastNameController,
            //   decoration: InputDecoration(labelText: "Last Name"),
            // ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              btnText: "Save",
              onClick: () {
                checkValues(btnController);
              },
              icon: Icons.arrow_right_alt,
              btnController: btnController,
            ),
            // FloatingActionButton.extended(
            //   label: Text('Next'), // <-- Text
            //   backgroundColor: colorsModel.orangeLightColors,
            //   icon: Icon(
            //     // <-- Icon
            //     Icons.arrow_right_alt,
            //     size: 24.0,
            //   ),
            //   onPressed: () {
            //     checkValues();
            //   },
            // ),
          ],
        ),
      )),
    );
  }
}
