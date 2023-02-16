import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';
import 'package:multi_language_firebase_chat_app/pages/SignIn.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/AnimatedButton.dart';
import '../models/UIHelper.dart';
import '../models/UserModel.dart';

String myCountry = "";
String country2 = "Country";
String flag = "";
String phoneCode = "";
String countryCode = "";

//String imageUrl = "";

// Future<void> uplodeData(UserModel userModel, String uid) async {
//   // String uid = "";
//   // User? user = FirebaseAuth.instance.currentUser;
//   // if (user != null) {
//   //   uid = user.uid;
//   // }
//   // DocumentSnapshot userData =
//   //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
//   // UserModel userModel =
//   //     UserModel.fromMap(userData.data() as Map<String, dynamic>);
//   // // UIHelper.showLoadingDialog(context, "Uploding image....");

//   // UploadTask uploadTask = FirebaseStorage.instance
//   //     .ref("profilepictures")
//   //     .child(uid.toString())
//   //     .child(uuid.v1())
//   //     .putFile(imageFile!);
//   //     log("done1");

//   //   TaskSnapshot uploadTask = await FirebaseStorage.instance
//   //   .ref("profilepictures")
//   //   .child(uid.toString())
//   //   .child(uuid.v1())
//   //   .putFile(imageFile!);;

//   // String pathdownlaod = await uploadTask.ref.getDownloadURL();

//   // TaskSnapshot snapshot = await uploadTask;
//   //     log("done2");
//   // String? imageUrl = await snapshot.ref.getDownloadURL();
//   //       log("done3");
//   //       log(imageUrl.toString());
//   //  userModel.profilepic = imageUrl;
//   //      log("done4");

//   //String? fullname = fullNameController.text.trim();

//   // widget.userModel.fullname = fullname;
//   // widget.userModel.profilepic = imageUrl;

//   // await FirebaseFirestore.instance
//   //     .collection("users")
//   //     .doc(widget.userModel.uid)
//   //     .set(widget.userModel.toMap())
//   //     .then((value) {
//   //   // Navigator.push(
//   //   //   context,
//   //   //   MaterialPageRoute(builder: (context) {
//   //   //     return HomePage(
//   //   //         userModel: widget.userModel, firebaseUser: widget.firebaseUser);
//   //   //   }),
//   //   // );
//   // });
//   log("Done4");

//   Reference ref = FirebaseStorage.instance
//       .ref("profilepictures")
//       .child(uid.toString())
//       .child(uuid.v1());
//   var uploadTask = await ref.putFile(imageFile!);

// //  String urlDownload;

//   if (uploadTask.state == TaskState.success) {
//     final urlDownload = await ref.getDownloadURL();
//     userModel.profilepic = urlDownload;

//     // return urlDownload;
//   }

//   // final snapshot = await uploadTask.whenComplete(() => {});
//   // final urlDownload = await snapshot.ref.getDownloadURL();
//   log("Done5");

//   // log(urlDownload.toString());

//   //return urlDownload;
// }

class CreatAccount extends StatefulWidget {
  //static final String path = "lib/src/pages/login/signup3.dart";

  @override
  _CreatAccountState createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount>
    with SingleTickerProviderStateMixin {
  //String imageFile = "";
  // File? imageFile;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  String firstname = "";
  String lastname = "";
  String phonenumber = "";
  String email = "";
  String password = "";
  String cPassword = "";
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  void checkValues(RoundedLoadingButtonController btn) {
    firstname = firstNameController.text.trim();
    lastname = lastNameController.text.trim();
    phonenumber = phoneNumberController.text.trim();
    email = emailController.text.trim();
    password = passwordController.text.trim();
    cPassword = cPasswordController.text.trim();
    // imageFile = imageUrl;

    if (firstname == "" ||
        lastname == "" ||
        phonenumber == "" ||
        email == "" ||
        password == "" ||
        cPassword == "" ||
        myCountry == "") {
      btn.error();
      UIHelper.showAlertDialogForSignIn(
          context, "Incomplete Data", "Please fill all the field", btn);
    } else if (password != cPassword) {
      btn.error();
      UIHelper.showAlertDialogForSignIn(context, "Password Mismatch",
          "The password you entered do noy match!", btn);
    } else {
      signUp(email, password, btn);
    }
  }

  void signUp(
      String email, String password, RoundedLoadingButtonController btn) async {
    UserCredential? credential;

    // UIHelper.showLoadingDialog(context, "Creating new account....");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      btn.success();
    } on FirebaseAuthException catch (ex) {
      btn.error();
      UIHelper.showAlertDialogForSignIn(
          context, "An error occurd", ex.message.toString(), btn);
      // Navigator.pop(context);
      // btn.reset();
    }
    if (credential != null) {
      User firebaseUser = credential.user!;
      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          firstname:
              firstname.replaceFirst(firstname[0], firstname[0].toUpperCase()),
          lastname:
              lastname.replaceFirst(lastname[0], lastname[0].toUpperCase()),
          number: phonenumber,
          profilepic: "",
          countryName: myCountry.toString(),
          countryFlag: flag.toString(),
          countryCode: countryCode,
          address: "",
          city: "",
          coverPhoto: "",
          facebook: "",
          github: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        // log("Done1");
        // //uplodeData(newUser, uid);
        // log("Done2");

        // newUser.profilepic = imageURL;
        log("Done3");

        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset("assets/animations/complete.json",
                        repeat: false,
                        controller: controller, onLoaded: (composition) {
                      controller.forward();
                    }),
                    Text(
                      "Profile Create Done",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              );
            });
        controller.addStatusListener((status) async {
          if (status == AnimationStatus.completed) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return CompleteProfile(
                  firebaseUser: firebaseUser,
                  userModel: newUser,
                );
              }),
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer("Signup For Free"),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: ListView(
                    // mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(
                          controller: firstNameController,
                          hint: "First name",
                          icon: Icons.person,
                          textType: TextInputType.name,
                          isPassword: false),
                      _textInput(
                          controller: lastNameController,
                          hint: "Last name",
                          icon: Icons.person,
                          textType: TextInputType.name,
                          isPassword: false),
                      _textInput(
                          controller: emailController,
                          hint: "Email",
                          icon: Icons.email,
                          textType: TextInputType.emailAddress,
                          isPassword: false),
                      _textInput(
                          controller: phoneNumberController,
                          hint: "Phone Number",
                          icon: Icons.call,
                          textType: TextInputType.number,
                          isPassword: false),
                      _textInput(
                          controller: passwordController,
                          hint: "Password",
                          icon: Icons.vpn_key,
                          textType: TextInputType.visiblePassword,
                          isPassword: true),
                      _textInput(
                          controller: cPasswordController,
                          hint: "Comfirm Password",
                          icon: Icons.vpn_key,
                          textType: TextInputType.visiblePassword,
                          isPassword: true),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Center(
                          child: ButtonWidget(
                            btnText: "Creat Account",
                            onClick: () {
                              // Navigator.pop(context);
                              checkValues(btnController);
                            },
                            btnController: btnController,
                            icon: Icons.verified_user_sharp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an acount?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignInPage();
                }));
              },
              child: Text(
                "Sign In",
                style: TextStyle(fontSize: 16, color: colorsModel.orangeColors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput({controller, hint, icon, textType, isPassword}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(

        controller: controller,
        obscureText: isPassword,
        keyboardType: textType,
        
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
          enabled: true
        ),
      ),
    );
  }
}

class HeaderContainer extends StatefulWidget {
  var text = "Signin";

  HeaderContainer(this.text);

  @override
  State<HeaderContainer> createState() => _HeaderContainerState();
}

class _HeaderContainerState extends State<HeaderContainer> {
  // void selectImage(ImageSource source) async {
  //   log("selectImage");
  //   XFile? pickedFile = await ImagePicker().pickImage(source: source);

  //   if (pickedFile != null) {
  //     cropImage(pickedFile);
  //   }
  // }

  // void cropImage(XFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: file.path,
  //       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //       compressQuality: 20);

  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = File(croppedImage.path);
  //     });
  //     // uplodeData();
  //   }
  // }

  // // void uplodeData() async {
  // //  // UIHelper.showLoadingDialog(context, "Uploding image....");

  // //   UploadTask uploadTask = FirebaseStorage.instance
  // //       .ref("profilepictures")
  // //       .child(FirebaseAuth.instance.currentUser!.uid.toString())
  // //       .child(uuid.v1())
  // //       .putFile(imageFile!);

  // //   TaskSnapshot snapshot = await uploadTask;

  // //   imageUrl = await snapshot.ref.getDownloadURL();

  // //   //String? fullname = fullNameController.text.trim();

  // //   // widget.userModel.fullname = fullname;
  // //   // widget.userModel.profilepic = imageUrl;

  // //   // await FirebaseFirestore.instance
  // //   //     .collection("users")
  // //   //     .doc(widget.userModel.uid)
  // //   //     .set(widget.userModel.toMap())
  // //   //     .then((value) {
  // //   //   // Navigator.push(
  // //   //   //   context,
  // //   //   //   MaterialPageRoute(builder: (context) {
  // //   //   //     return HomePage(
  // //   //   //         userModel: widget.userModel, firebaseUser: widget.firebaseUser);
  // //   //   //   }),
  // //   //   // );
  // //   // });
  // // }

  // void showPhotoOption() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Uplode Profile Picture"),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ListTile(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   selectImage(ImageSource.gallery);
  //                 },
  //                 leading: Icon(Icons.photo_album_rounded),
  //                 title: Text("Select from Gallery"),
  //               ),
  //               ListTile(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   selectImage(ImageSource.camera);
  //                 },
  //                 leading: Icon(Icons.camera_alt),
  //                 title: Text("Take a Photo"),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [colorsModel.orangeColors, colorsModel.orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                widget.text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "lib/images/languages.png",
                    height: 100,
                    width: 100,
                  ),
                ),

                // SizedBox(
                //   width: 120,
                //   height: 120,
                //   child: Stack(
                //     //alignment: AlignmentDirectional.center,
                //     children: <Widget>[
                //       //avatar
                //       Material(
                //         color: Colors.transparent,
                //         child: Ink(
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.yellow, width: 2),
                //             shape: BoxShape.circle,
                //             image: DecorationImage(
                //                 image: NetworkImage(
                //                     "https://assets-global.website-files.com/5ec7dad2e6f6295a9e2a23dd/6222481c0ad8761618b18e7e_profile-picture.jpg"),
                //                 fit: BoxFit.cover),
                //           ),
                //         ),
                //       ),
                //       Align(
                //         alignment: Alignment(1.3, 1.3),
                //         child: MaterialButton(
                //           minWidth: 0,
                //           child: Icon(Icons.camera_alt),
                //           onPressed: () {
                //             showPhotoOption();
                //           },
                //           textColor: Colors.white,
                //           color: Theme.of(context).accentColor,
                //           elevation: 0,
                //           shape: CircleBorder(),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: (flag == "")
                      ? Text(
                          "Choice Country",
                          style: TextStyle(color: Colors.black87),
                        )
                      : Text(
                          "${flag.toString() + myCountry.toString()}",
                          style: TextStyle(color: Colors.black87),
                        ),
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      countryListTheme: CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle:
                            TextStyle(fontSize: 16, color: Colors.blueGrey),
                        bottomSheetHeight: 500,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        //Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      countryFilter: <String>['BD', 'IN', 'RU', 'US', 'FR'],
                      onSelect: (Country country) {
                        log('Select country: ${country.name}');
                        setState(() {
                          myCountry = country.name;
                          phoneCode = "+" + country.phoneCode;
                          flag = country.flagEmoji;
                          if (myCountry == "Bangladesh") {
                            countryCode = "bn";
                          } else if (myCountry == "India") {
                            countryCode = "hi";
                          } else if (myCountry == "Russia") {
                            countryCode = "ru";
                          } else if (myCountry == "United States") {
                            countryCode = "en";
                          } else if (myCountry == "France") {
                            countryCode = "fr";
                          }
                        });
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 8),
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),

                  // child: Text(flag.toString() + phoneCode.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ButtonWidget extends StatelessWidget {
//   String? btnText = "";
//   var onClick;
//   var btnController;

//   ButtonWidget({this.btnText, this.onClick, this.btnController});

//   @override
//   Widget build(BuildContext context) {
//     return RoundedLoadingButton(
//       controller: btnController,
//       onPressed: onClick,
//       child: Text(btnText!),
//       color: Colors.orange,
//     );
    //  InkWell(
    //   onTap: onClick,
    //   child: Container(
    //     margin: EdgeInsets.only(left: 25, right: 25),
    //     width: double.infinity,
    //     height: 40,
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //           colors: [orangeColors, orangeLightColors],
    //           end: Alignment.centerLeft,
    //           begin: Alignment.centerRight),
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(100),
    //       ),
    //     ),
    //     alignment: Alignment.center,
    //     child: Text(
    //       btnText!,
    //       style: TextStyle(
    //           fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    //     ),
    //   ),
//     // );
//   }
// }
