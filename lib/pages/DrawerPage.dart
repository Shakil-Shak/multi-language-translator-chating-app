import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_language_firebase_chat_app/pages/EditProfile.dart';
import 'package:multi_language_firebase_chat_app/pages/UserProfilePage.dart';
import 'package:multi_language_firebase_chat_app/pages/UserProfilePage2.dart';

import '../models/UserModel.dart';
import 'Profile.dart';
import 'SignIn.dart';

class DrawerPage extends StatefulWidget {
  final UserModel userModel;
  final firebaseUser;

  const DrawerPage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  _buildDrawer() {
    //final String image = widget.userModel.profilepic!;
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${widget.userModel.countryCode.toString().toUpperCase()}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        //avatar
                        Material(
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.orange, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'lib/images/profile.png',
                                    image: widget.userModel.profilepic!)),
                          ),
                        ),
                        Align(
                          alignment: Alignment(2.1, 1.4),
                          child: MaterialButton(
                            minWidth: 0,
                            child: Text(
                              "${widget.userModel.countryFlag!}",
                              style: TextStyle(fontSize: 30),
                            ),
                            onPressed: () {
                              //showPhotoOption();
                            },
                            // textColor: Colors.white,
                            //color: Theme.of(context).accentColor,
                            elevation: 0,
                            shape: CircleBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${widget.userModel.firstname} " +
                        "${widget.userModel.lastname}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${widget.userModel.countryName}",
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(Icons.person_pin, "My profile", active),
                  _buildDivider(),
                  _buildRow(Icons.edit, "Edit profile", active),
                  _buildDivider(),
                  _buildRow(Icons.color_lens, "Change Theme", active),
                  _buildDivider(),
                  _buildRow(Icons.feedback, "Feedback", active),
                  _buildDivider(),
                  _buildRow(Icons.info_outline, "Terms and conditions", active),
                  _buildDivider(),
                  _buildRow(Icons.perm_device_information, "About us", active),
                  _buildDivider(),
                  _buildRow(Icons.star_rate, "Rate this app", active),
                  _buildDivider(),
                  _buildRow(Icons.logout, "Logout", Colors.red),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, Color color,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: color, fontSize: 16.0);
    return InkWell(
      onTap: () {
        switch (title) {
          case "My profile":
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserProfile2(userModel: widget.userModel);
            }));
            break;
          case "Edit profile":
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditProfile(userModel: widget.userModel);
            }));
            break;
          case "Change Theme":
            Fluttertoast.showToast(
                msg: "Under Developing",
                toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                // backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case "Feedback":
            Fluttertoast.showToast(
                msg: "Under Developing",
                toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                // backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case "Terms and conditions":
            Fluttertoast.showToast(
                msg: "Under Developing",
                toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                // backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case "About us":
            Fluttertoast.showToast(
                msg: "Under Developing",
                toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                // backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case "Rate this app":
            Fluttertoast.showToast(
                msg: "Under Developing",
                toastLength: Toast.LENGTH_SHORT,
                // gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                // backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case "Logout":
            FirebaseAuth.instance.signOut();
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return SignInPage();
              },
            ));
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          // if (showBadge)
          //   Material(
          //     color: Colors.deepOrange,
          //     elevation: 5.0,
          //     shadowColor: Colors.red,
          //     borderRadius: BorderRadius.circular(5.0),
          //     child: Container(
          //       width: 25,
          //       height: 25,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //         color: Colors.deepOrange,
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //       child: Text(
          //         "10+",
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.0,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer();
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
