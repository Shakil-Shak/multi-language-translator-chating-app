import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';
import 'package:multi_language_firebase_chat_app/pages/CreatAccount.dart';
import 'package:multi_language_firebase_chat_app/pages/HomePage.dart';
import 'package:multi_language_firebase_chat_app/pages/NoInternetConnection.dart';

import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          if (currentUser != null) {
            UserModel? thisUserModel =
                await FirebaseHelper.getUserModelById(currentUser.uid);

            if (thisUserModel != null) {
              if (thisUserModel.profilepic.toString() == "") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CompleteProfile(
                    firebaseUser: currentUser,
                    userModel: thisUserModel,
                  );
                }));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage(
                    firebaseUser: currentUser,
                    userModel: thisUserModel,
                  );
                }));
              }
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreatAccount();
              }));
            }
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreatAccount();
            }));
          }
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoInternetConnection();
          }));
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset("assets/animations/splashScreen.json",
              repeat: false, controller: controller, onLoaded: (composition) {
        controller.forward();
      })),
    );
  }
}
