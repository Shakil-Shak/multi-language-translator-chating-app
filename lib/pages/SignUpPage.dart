//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:language_picker/languages.g.dart';
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';
import 'package:multi_language_firebase_chat_app/pages/Login_with_phone.dart';

import '../models/UIHelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  final supportedLanguages = [
    Languages.english,
    Languages.french,
    Languages.japanese,
    Languages.korean,
  ];

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the field");
    } else if (password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The password you entered do noy match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account....");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error occurd", ex.message.toString());
    }
    if (credential != null) {
      User firebaseUser = credential.user!;
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, firstname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return CompleteProfile(
              firebaseUser: firebaseUser,
              userModel: newUser,
            );
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Image.asset(
                "lib/images/language.png",
                height: 170,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: cPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
              SizedBox(
                height: 30,
              ),

              // CupertinoButton(
              //   onPressed: () {
              //     showCountryPicker(
              //       //countryFilter: <String>['EN', 'BN'],
              //       context: context,
              //       showPhoneCode:
              //           true, // optional. Shows phone code before the country name.
              //       onSelect: (Country country) {
              //         //print('Select country: ${country.displayName}');
              //         log('Select country: ${country.name}');
              //       },
              //     );
              //   },
              //   color: Colors.grey[800],
              //   child: Text("Choice country"),
              // ),
              SizedBox(
                height: 30,
              ),
              CupertinoButton(
                onPressed: () {
                  checkValues();
                },
                color: Colors.grey[800],
                child: Text("Sign Up"),
              ),
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
