import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/EditProfile.dart';
import 'package:multi_language_firebase_chat_app/pages/HomePage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/AnimatedButton.dart';
import '../models/UserModel.dart';

class UserProfile2 extends StatefulWidget {
  final UserModel userModel;

  const UserProfile2({required this.userModel});
  @override
  State<UserProfile2> createState() => _UserProfile2State();
}

class _UserProfile2State extends State<UserProfile2> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final image = "lib/images/profile.png";
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  void onClick(RoundedLoadingButtonController btn) {
    btn.stop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditProfile(
          userModel: widget.userModel,
        );
      }),
      // (route) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: (widget.userModel.coverPhoto != "")
                    ? FadeInImage.assetNetwork(
                        placeholder: 'lib/images/profile.png',
                        image: widget.userModel.coverPhoto!,
                        fit: BoxFit.cover)
                    : Image.asset("lib/images/languages.png"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                  colors: [
                                    colorsModel.orangeColors,
                                    colorsModel.orangeLightColors
                                  ],
                                  end: Alignment.bottomCenter,
                                  begin: Alignment.topCenter)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Text(
                                    //   "Little Butterfly",
                                    // ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        "${widget.userModel.firstname} " +
                                            "${widget.userModel.lastname}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle:
                                          Text(widget.userModel.countryName!),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              // Row(
                              //   children: <Widget>[
                              //     Expanded(
                              //       child: Column(
                              //         children: <Widget>[
                              //           Text("285"),
                              //           Text("Likes")
                              //         ],
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Column(
                              //         children: <Widget>[
                              //           Text("3025"),
                              //           Text("Comments")
                              //         ],
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Column(
                              //         children: <Widget>[
                              //           Text("650"),
                              //           Text("Favourites")
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
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
                                      Border.all(color: Colors.white, width: 4),
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
                        Positioned(
                            bottom: 40,
                            right: 30,
                            child: Icon(
                              Icons.logout_outlined,
                              size: 35,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: colorsModel.orangeLightColors,
                              borderRadius: BorderRadius.circular(5.0),
                              // gradient: LinearGradient(
                              //     colors: [
                              //       colorsModel.orangeColors,
                              //       colorsModel.orangeLightColors
                              //     ],
                              //     end: Alignment.bottomCenter,
                              //     begin: Alignment.topCenter)
                            ),
                            child: ListTile(
                              title: Text(
                                "User information",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          //Divider(),
                          ExpansionTile(
                            title: ListTile(
                              title: Text("Email"),
                              // subtitle: Text(widget.userModel.email!),
                              leading: Icon(Icons.email),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Text(widget.userModel.email!),
                                // subtitle: Text(widget.userModel.email!),
                                leading: Icon(Icons.person),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: ListTile(
                              title: Text("Contact Number"),
                              // subtitle: Text(widget.userModel.email!),
                              leading: Icon(Icons.contact_phone),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Text(widget.userModel.number!),
                                // subtitle: Text(widget.userModel.email!),
                                leading: Icon(Icons.phone),
                              ),
                            ],
                          ),

                          ExpansionTile(
                            title: ListTile(
                              title: Text("Location"),
                              // subtitle: Text(widget.userModel.email!),
                              leading: Icon(Icons.contact_phone),
                            ),
                            children: <Widget>[
                              Visibility(
                                visible: (widget.userModel.city == "")
                                    ? (false)
                                    : (true),
                                child: ListTile(
                                  title: Text("City"),
                                  subtitle: Text(widget.userModel.city!),
                                  leading: Icon(Icons.location_city),
                                ),
                              ),
                              Visibility(
                                visible: (widget.userModel.address == "")
                                    ? (false)
                                    : (true),
                                child: ListTile(
                                  title: Text("City"),
                                  subtitle: Text(widget.userModel.address!),
                                  leading: Icon(Icons.location_city),
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: ListTile(
                              title: Text("Social Link"),
                              // subtitle: Text(widget.userModel.email!),
                              leading: Icon(Icons.link),
                            ),
                            children: <Widget>[
                              Visibility(
                                visible: (widget.userModel.facebook == "")
                                    ? (false)
                                    : (true),
                                child: ListTile(
                                  title: Text(widget.userModel.facebook!),
                                  subtitle: Text("Facebook"),
                                  leading: Icon(Icons.facebook),
                                ),
                              ),
                              Visibility(
                                visible: (widget.userModel.github == "")
                                    ? (false)
                                    : (true),
                                child: ListTile(
                                  title: Text(widget.userModel.github!),
                                  subtitle: Text("Github"),
                                  leading: Icon(Icons.link),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: (widget.userModel.uid ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? true
                                : false,
                            child: ButtonWidget(
                              btnController: btnController,
                              btnText: "Edit Profile",
                              onClick: () {
                                onClick(btnController);
                              },
                              icon: Icons.edit,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) {
                      //     return HomePage(
                      //       userModel: widget.userModel,
                      //       firebaseUser: currentUser,
                      //     );
                      //   }),
                      //   // (route) => true,
                      // );
                    },
                    icon: Icon(Icons.arrow_back)),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
