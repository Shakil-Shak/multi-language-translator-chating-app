import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/CompletePage.dart';

import '../models/UserModel.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;

  const UserProfile({required this.userModel});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: Text("View Profile"),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.5, 0.9],
                    colors: [colorsModel.orangeColors, colorsModel.orangeLightColors])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Visibility(
                      visible: (widget.userModel.uid ==
                              FirebaseAuth.instance.currentUser!.uid)
                          ? false
                          : true,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.call,
                          size: 30.0,
                          color: colorsModel.orangeLightColors,
                        ),
                        minRadius: 30.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Container(
                      height: 115,
                      width: 115,
                      child: Stack(
                        children: [
                          //avatar
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 4),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'lib/images/profile.png',
                                    image: widget.userModel.profilepic!)),
                          ),
                          Align(
                            alignment: Alignment(1.8, 1.2),
                            child: MaterialButton(
                              height: 45,
                              minWidth: 4,
                              child: Text(
                                "${widget.userModel.countryFlag!}",
                                style: TextStyle(fontSize: 28),
                              ),
                              onPressed: () {
                                //showPhotoOption();
                              },
                              // textColor: Colors.white,
                              color: Colors.white,
                              elevation: 0,
                              shape: CircleBorder(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (widget.userModel.uid ==
                              FirebaseAuth.instance.currentUser!.uid)
                          ? false
                          : true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.message,
                            size: 30.0,
                            color: colorsModel.orangeColors,
                          ),
                          minRadius: 30.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.userModel.firstname} " +
                      "${widget.userModel.lastname}",
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
              ],
            ),
          ),
          // Container(
          //   // height: 50,
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           color: Colors.deepOrange.shade300,
          //           child: ListTile(
          //             title: Text(
          //               "50895",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 24.0),
          //             ),
          //             subtitle: Text(
          //               "FOLLOWERS",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.red),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           color: Colors.red,
          //           child: ListTile(
          //             title: Text(
          //               "34524",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 24.0),
          //             ),
          //             subtitle: Text(
          //               "FOLLOWING",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.white70),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(
            title: Text(
              "Country",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "${widget.userModel.countryName}",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
              "Email",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "${widget.userModel.email}",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Phone",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "${widget.userModel.number}",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Twitter",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "@ramkumar",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Facebook",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "facebook.com/ramkumar",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
