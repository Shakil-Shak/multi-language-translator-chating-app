import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multi_language_firebase_chat_app/pages/SplashScreen.dart';
import 'package:uuid/uuid.dart';

import 'models/NotificationApi.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationModel.initialize(flutterLocalNotificationsPlugin);

  // User? currentUser = FirebaseAuth.instance.currentUser;
  // bool result = await InternetConnectionChecker().hasConnection;
  // if (result == true) {
  //   if (currentUser != null) {
  //     UserModel? thisUserModel =
  //         await FirebaseHelper.getUserModelById(currentUser.uid);

  //     if (thisUserModel != null) {
  //       if (thisUserModel.profilepic.toString() == "") {
  //         runApp(UplodeImage(
  //           userModel: thisUserModel,
  //           firebaseUser: currentUser,
  //         ));
  //       } else {
  //         runApp(MyAppLoggedIn(
  //           userModel: thisUserModel,
  //           firebaseUser: currentUser,
  //         ));
  //       }
  //     } else {
  //       runApp(MyApp());
  //     }
  //   } else {
  //     runApp(MyApp());
  //   }
  // } else {
  //   runApp(NoInternet());
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// class UplodeImage extends StatelessWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const UplodeImage(
//       {super.key, required this.userModel, required this.firebaseUser});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CompleteProfile(
//         userModel: userModel,
//         firebaseUser: firebaseUser,
//       ),
//     );
//   }
// }

// class MyAppLoggedIn extends StatelessWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const MyAppLoggedIn(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(
//         userModel: userModel,
//         firebaseUser: firebaseUser,
//       ),
//     );
//   }
// }

// class NoInternet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false, home: NoInternetConnection());
//   }
// }
