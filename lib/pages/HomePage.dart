import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/models/UIHelper.dart';
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/SearchPage.dart';

import '../models/ChatRoomModel.dart';
import '../models/FirebaseHelper.dart';
import 'ChatRoomPage.dart';
import 'DrawerPage.dart';
import 'UserProfilePage2.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future deleteData(String id) async {
    try {
      await FirebaseFirestore.instance.collection("chatrooms").doc(id).delete();
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorsModel.orangeColors,
              colorsModel.orangeLightColors
            ], end: Alignment.centerLeft, begin: Alignment.centerRight),
          ),
        ),
        // backgroundColor: Colors.grey[800],
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) {
        //       return Profile(userModel: widget.userModel);
        //     }));
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(left: 14),
        //     child: CircleAvatar(
        //         backgroundImage:
        //             NetworkImage(widget.userModel.profilepic.toString())),
        //   ),
        // ),
        centerTitle: true,
        title: Text(widget.userModel.firstname!),

        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserProfile2(userModel: widget.userModel);
              }));
            },
            child: Container(
                margin: EdgeInsets.only(left: 14, bottom: 3, top: 3),
                child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        placeholder: 'lib/images/profile.png',
                        image: widget.userModel.profilepic!))),
          ),
          SizedBox(
            width: 15,
          ),
          // InkWell(
          //   onTap: () {
          //     Fluttertoast.showToast(
          //       msg: "Your country is ${widget.userModel.countryName}",
          //       toastLength: Toast.LENGTH_SHORT,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.black,
          //       textColor: Colors.white,
          //       fontSize: 16.0,
          //     );
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(right: 15),
          //     child: Center(
          //         child: Text(
          //       "${widget.userModel.countryFlag.toString()}",
          //       style: TextStyle(fontSize: 30),
          //     )),
          //   ),
          // )
        ],
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/images/languages.png',
              ),
              fit: BoxFit.contain,
              opacity: 0.3),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      final item = chatRoomSnapshot.docs[index];
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                          future: FirebaseHelper.getUserModelById(
                              participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;

                                return Dismissible(
                                  key: Key(item.toString()),
                                  onDismissed: (direction) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Warning"),
                                            content:
                                                Text("Confirm Delete Chat?"),
                                            actions: [
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Confirm"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    chatRoomSnapshot.docs
                                                        .removeAt(index);
                                                  });
                                                  deleteData(chatRoomModel
                                                      .chatroomid
                                                      .toString());
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    child: Icon(Icons.delete),
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                          chatroom: chatRoomModel,
                                          firebaseUser: widget.firebaseUser,
                                          userModel: widget.userModel,
                                          targetUser: targetUser,
                                        );
                                      }));
                                    },
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            targetUser.profilepic.toString())),
                                    title:
                                        Text(targetUser.firstname.toString()),
                                    tileColor: Colors.grey[200],
                                    subtitle: (chatRoomModel.lastMessage1
                                                    .toString() !=
                                                "" ||
                                            chatRoomModel.lastMessage2
                                                    .toString() !=
                                                "")
                                        ? ((chatRoomModel.lastMessageUid
                                                    .toString() ==
                                                widget.userModel.uid)
                                            ? Text(
                                                chatRoomModel.lastMessage1
                                                    .toString(),
                                                maxLines: 1,
                                              )
                                            : Text(
                                                chatRoomModel.lastMessage2
                                                    .toString(),
                                                maxLines: 1,
                                              ))
                                        : Text(
                                            "Say hi to your friend!",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            maxLines: 1,
                                          ),
                                    trailing: Text(
                                      "${targetUser.countryFlag!}",
                                      style: TextStyle(fontSize: 23),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                    // child: Center(
                                    //     child: Text(
                                    //   "No chats avilable",
                                    //   style: TextStyle(color: Colors.black),
                                    // )),
                                    );
                              }
                            } else {
                              return Container(
                                  // child: Center(
                                  //     child: Text(
                                  //   "No chats avilable",
                                  //   style: TextStyle(color: Colors.black),
                                  // )),
                                  );
                            }
                          });
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: Text("No Chats"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorsModel.orangeLightColors,
        onPressed: () {
          UIHelper.showLoadingDialog(context, "Loading....");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
