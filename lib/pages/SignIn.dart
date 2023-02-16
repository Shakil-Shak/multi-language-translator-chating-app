/**
 * Author: Ambika Dulal
 * profile: https://github.com/ambikadulal
  */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/AnimatedButton.dart';
import '../models/UIHelper.dart';
import '../models/UserModel.dart';
import 'CreatAccount.dart';
import 'HomePage.dart';

class SignInPage extends StatefulWidget {
  static final String path = "lib/images/languages.png";
  @override
  _SignInPageFourteenState createState() => _SignInPageFourteenState();
}

class _SignInPageFourteenState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  void checkValues(RoundedLoadingButtonController btn) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      btn.error();
      UIHelper.showAlertDialogForSignIn(
          context, "Incomplete Data", "Please fill all the field", btn);
    } else {
      logIn(email, password, btn);
    }
  }

  void logIn(
      String email, String password, RoundedLoadingButtonController btn) async {
    UserCredential? credential;

    //UIHelper.showLoadingDialog(context, "Logging In....");

    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      btn.success();
    } on FirebaseAuthException catch (ex) {
      //Navigator.pop(context);
      btn.error();
      UIHelper.showAlertDialogForSignIn(
          context, "An error occurd", ex.message.toString(), btn);
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return (userModel.profilepic.toString() == "")
              ? CompleteProfile(
                  userModel: userModel, firebaseUser: credential!.user!)
              : HomePage(userModel: userModel, firebaseUser: credential!.user!);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ListView(
                  children: <Widget>[
                    _textInput(
                        controller: emailController,
                        hint: "Enter your Email",
                        icon: Icons.email,
                        textType: TextInputType.emailAddress,
                        isPassword: false),
                    _textInput(
                        controller: passwordController,
                        hint: "Password",
                        icon: Icons.vpn_key,
                        textType: TextInputType.visiblePassword,
                        isPassword: true),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Center(
                        child:
                            //     RoundedLoadingButton(
                            //   controller: btnController,
                            //   onPressed: () {
                            //     checkValues(btnController);
                            //   },
                            //   child: Text("Sign Up"),
                            // ),
                            ButtonWidget(
                          btnText: "Sign In",
                          onClick: () {
                            // Navigator.pop(context);
                            checkValues(btnController);
                          },
                          btnController: btnController,
                          icon: Icons.login,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CreatAccount();
                }));
              },
              child: Text(
                "Sign Up",
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
        ),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text);

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
                text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Image.asset(
              "lib/images/languages.png",
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
