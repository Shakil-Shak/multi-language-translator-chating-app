import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_language_firebase_chat_app/pages/UserProfilePage2.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../main.dart';
import '../models/AnimatedButton.dart';
import '../models/UserModel.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;

  const EditProfile({required this.userModel});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController githubController = TextEditingController();

  String firstname = "";
  String lastname = "";
  String phonenumber = "";
  String city = "";
  String address = "";
  String facebook = "";
  String github = "";
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  File? profileImageFile, coverImageFile;
  String? profileImageUrl, coverImageUrl;
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

  void onClick(RoundedLoadingButtonController btn) async {
    if (profileImageFile != null) {
      UploadTask uploadTaskP = FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid.toString())
          .child("profilepictures")
          .child(uuid.v1())
          .putFile(profileImageFile!);

      TaskSnapshot snapshotP = await uploadTaskP;

      profileImageUrl = await snapshotP.ref.getDownloadURL();
      widget.userModel.profilepic = profileImageUrl;
    }
    if (coverImageFile != null) {
      UploadTask uploadTaskC = FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid.toString())
          .child("coverpictures")
          .child(uuid.v1())
          .putFile(coverImageFile!);

      TaskSnapshot snapshotC = await uploadTaskC;

      coverImageUrl = await snapshotC.ref.getDownloadURL();
      widget.userModel.coverPhoto = coverImageUrl;
    }
    firstname = firstNameController.text.trim();
    lastname = lastNameController.text.trim();
    phonenumber = phoneNumberController.text.trim();
    address = addressController.text.trim();
    city = cityController.text.trim();
    facebook = facebookController.text.trim();
    github = githubController.text.trim();
    //email = emailController.text.trim();
    // String uid = widget.userModel.uid.toString();
    // final _db = FirebaseFirestore.instance;
    widget.userModel.firstname =
        firstname.replaceFirst(firstname[0], firstname[0].toUpperCase());
    widget.userModel.lastname =
        lastname.replaceFirst(firstname[0], firstname[0].toUpperCase());
    widget.userModel.number = phonenumber;
    widget.userModel.city = city;
    widget.userModel.address = address;
    widget.userModel.facebook = facebook;
    widget.userModel.github = github;

    btn.success();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      btn.reset();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return UserProfile2(userModel: widget.userModel);
        }),
        (route) => true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text = widget.userModel.firstname!;
    lastNameController.text = widget.userModel.lastname!;
    phoneNumberController.text = widget.userModel.number!;
    cityController.text = widget.userModel.city!;
    addressController.text = widget.userModel.address!;
    facebookController.text = widget.userModel.facebook!;
    githubController.text = widget.userModel.github!;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Profile Picture",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            //avatar
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 4),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                  child: (profileImageFile == null)
                                      ? FadeInImage.assetNetwork(
                                          placeholder: 'lib/images/profile.png',
                                          image: widget.userModel.profilepic!)
                                      : Image.file(
                                          profileImageFile!,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            Align(
                              alignment: Alignment(1.8, 1.2),
                              child: MaterialButton(
                                height: 40,
                                minWidth: 4,
                                child: Icon(Icons.edit),
                                onPressed: () {
                                  showPhotoOption("p");
                                },
                                // textColor: Colors.white,
                                color: Colors.grey,
                                elevation: 0,
                                shape: CircleBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Text(
                        "Cover Picture",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          Container(
                              height: 200,
                              width: double.infinity,
                              child: (coverImageFile == null)
                                  ? (widget.userModel.coverPhoto != "")
                                      ? FadeInImage.assetNetwork(
                                          placeholder: 'lib/images/profile.png',
                                          image: widget.userModel.coverPhoto!,
                                          fit: BoxFit.cover)
                                      : Center(child: Text("No Cover Photo"))
                                  : Image.file(
                                      coverImageFile!,
                                      fit: BoxFit.cover,
                                    )),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: MaterialButton(
                              height: 40,
                              minWidth: 4,
                              child: Icon(Icons.edit),
                              onPressed: () {
                                showPhotoOption("c");
                              },
                              // textColor: Colors.white,
                              color: Colors.grey,
                              elevation: 0,
                              shape: CircleBorder(),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  title: Text("First Name"),
                  subtitle: TextFormField(
                    controller: firstNameController,
                    //controller: firstNameController,
                  ),
                  leading: Icon(Icons.email),
                ),
                Divider(),
                ListTile(
                  title: Text("Last Name"),
                  subtitle: TextFormField(
                    controller: lastNameController,
                  ),
                  leading: Icon(Icons.email),
                ),
                Divider(),
                ListTile(
                  title: Text("Email"),
                  subtitle: TextFormField(
                    enabled: false,
                    initialValue: widget.userModel.email,
                  ),
                  leading: Icon(Icons.email),
                ),
                Divider(),
                ListTile(
                  title: Text("Phone"),
                  subtitle: TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  leading: Icon(Icons.phone),
                ),
                Divider(),
                ListTile(
                  title: Text("City"),
                  subtitle: TextFormField(
                    controller: cityController,
                  ),
                  leading: Icon(Icons.location_city),
                ),
                Divider(),
                ListTile(
                  title: Text("Address"),
                  subtitle: TextFormField(
                    controller: addressController,
                  ),
                  leading: Icon(Icons.location_city),
                ),
                Divider(),
                ListTile(
                  title: Text("Facebook"),
                  subtitle: TextFormField(
                    controller: facebookController,
                  ),
                  leading: Icon(Icons.facebook),
                ),
                Divider(),
                ListTile(
                  title: Text("Github"),
                  subtitle: TextFormField(
                    controller: githubController,
                  ),
                  leading: Icon(Icons.link),
                ),
                Divider(),
                ButtonWidget(
                  btnText: "Save",
                  onClick: () {
                    onClick(btnController);
                  },
                  icon: Icons.save,
                  btnController: btnController,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
