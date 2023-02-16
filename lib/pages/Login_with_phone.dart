import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';
import 'package:multi_language_firebase_chat_app/pages/HomePage.dart';

import '../models/UserModel.dart';

enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FROM_WIDGET }

class Login_With_Phone extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Login_With_Phone(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  _Login_With_PhoneState createState() => _Login_With_PhoneState();
}

class _Login_With_PhoneState extends State<Login_With_Phone> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
  String verificationID = "";
  String country2 = "Country";
  String flag = "";
  String phoneCode = "";

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      // final authCred = await _auth.signInWithCredential(phoneAuthCredential);
      //final User? user = _auth.currentUser;
      final authCred =
          await widget.firebaseUser.linkWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        // String uid = authCred.user!.uid;
        // DocumentSnapshot userData =
        //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
        // UserModel userModel =
        //     UserModel.fromMap(userData.data() as Map<String, dynamic>);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CompleteProfile(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                    )));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

  showMobilePhoneWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          "Verify Your Phone Number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 7,
        ),
        Text("Enter The Code Sent To +88${phoneController.text}"),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              child: (flag == "")
                  ? Text("Country")
                  : Text(flag.toString() + phoneCode.toString()),
              onPressed: () {
                showCountryPicker(
                  context: context,
                  countryListTheme: CountryListThemeData(
                    flagSize: 25,
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
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
                  countryFilter: <String>['BD', 'IN', 'CN', 'RU', 'GB', 'US'],
                  onSelect: (Country country) {
                    log('Select country: ${country.name}');
                    setState(() {
                      phoneCode = "+" + country.phoneCode;
                      flag = country.flagEmoji;
                    });
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 82, 177, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  textStyle: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),

              // child: Text(flag.toString() + phoneCode.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: "Enter Your Phone Number"),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              await _auth.verifyPhoneNumber(
                  phoneNumber: "${phoneCode.toString() + phoneController.text}",
                  verificationCompleted: (phoneAuthCredential) async {},
                  verificationFailed: (verificationFailed) {
                    log(verificationFailed.toString());
                  },
                  codeSent: (verificationID, resendingToken) async {
                    setState(() {
                      currentState = LoginScreen.SHOW_OTP_FROM_WIDGET;
                      this.verificationID = verificationID;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationID) async {});
            },
            child: Text("Send OTP")),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
    );
  }

  showOtpFromWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          "Enter Your OTP",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 7,
        ),
        Text("Enter The Code Sent To +88${phoneController.text}"),
        SizedBox(
          height: 20,
        ),
        Center(
          child: TextField(
            // onChanged: (String value) async {
            //   if(value.length == 6){
            //     setState(() {
            //       isOTPDisabled = false;
            //     });
            //   }else{
            //     setState(() {
            //       isOTPDisabled = true;
            //     });
            //   }
            //
            // },
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Enter Your OTP"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationID, smsCode: otpController.text);

              signInWithPhoneAuthCred(phoneAuthCredential);
            },
            child: Text("Verify")),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentState == LoginScreen.SHOW_MOBILE_ENTER_WIDGET
          ? showMobilePhoneWidget(context)
          : showOtpFromWidget(context),
    );
  }
}
