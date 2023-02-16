import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multi_language_firebase_chat_app/main.dart';
import 'package:multi_language_firebase_chat_app/models/ChatRoomModel.dart';
import 'package:multi_language_firebase_chat_app/models/MessageModel.dart';
import 'package:multi_language_firebase_chat_app/models/NotificationApi.dart';
import 'package:multi_language_firebase_chat_app/models/UIHelper.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:translator/translator.dart';

import '../models/UserModel.dart';
import 'UserProfilePage2.dart';

//MessageModel? currentMessage2;

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  //TranslationChat translationChat = TranslationChat();
  final translator = GoogleTranslator();
  String? new_msg;
  String language = 'en';
  String? msg;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //final NotificationModel notifications = NotificationModel();

  // void trans(String msg1) async {
  //   var translation = await translator.translate(msg1.toString(), to: 'bn');
  //   setState(() {
  //     new_msg = translation.text;
  //   });
  // }

  void sendmessage() async {
    msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      var translation = await translator.translate(msg!,
          to: widget.targetUser.countryCode.toString());
      new_msg = translation.text;
      //trans(msg.toString());

      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        trns_text: new_msg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      //     .then((value) {
      //   NotificationModel.showNotification(
      //       title: "Shakil", body: "My name is shakil", payload: "Chat app");
      // });

      widget.chatroom.lastMessage1 = msg;
      widget.chatroom.lastMessage2 = new_msg;
      widget.chatroom.lastMessageUid = widget.userModel.uid;

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap())
          .then((value) {
        NotificationModel.sendNotification(
            title: widget.userModel.firstname!,
            message: widget.chatroom.lastMessage1!,
            token: widget.targetUser.fcmToken);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // NotificationModel.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      NotificationModel.showBigTextNotification(
          // title: widget.targetUser.firstname!,
          message: message,
          fln: flutterLocalNotificationsPlugin);
    });

    NotificationModel.storeToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorsModel.orangeColors,
              colorsModel.orangeLightColors
            ], end: Alignment.centerLeft, begin: Alignment.centerRight),
          ),
        ),
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserProfile2(userModel: widget.targetUser);
                }));
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                      placeholder: 'lib/images/profile.png',
                      image: widget.userModel.profilepic!),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.firstname.toString()),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showModalBottomSheet<void>(
        //         shape: RoundedRectangleBorder(
        //           borderRadius:
        //               BorderRadius.vertical(top: Radius.circular(20.0)),
        //         ),
        //         context: context,
        //         builder: (BuildContext context) {
        //           return Flexible(
        //             child: Container(
        //               //color: Colors.white,
        //               child: Column(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   ListTile(
        //                     onTap: () {
        //                       language = 'fr';
        //                       Navigator.pop(context);
        //                     },
        //                     leading: CircleAvatar(
        //                         backgroundImage: NetworkImage(
        //                             "https://cdn-icons-png.flaticon.com/512/197/197560.png")),
        //                     title: Text("French"),
        //                     trailing: Text("Free"),
        //                   ),
        //                   ListTile(
        //                     onTap: () {
        //                       language = 'ru';
        //                       Navigator.pop(context);
        //                     },
        //                     leading: CircleAvatar(
        //                         backgroundImage: NetworkImage(
        //                             "https://cdn-icons-png.flaticon.com/512/323/323300.png")),
        //                     title: Text("Russian"),
        //                     trailing: Text("Free"),
        //                   ),
        //                   ListTile(
        //                     onTap: () {
        //                       language = 'hi';
        //                       Navigator.pop(context);
        //                     },
        //                     leading: CircleAvatar(
        //                         backgroundImage: NetworkImage(
        //                             "https://cdn-icons-png.flaticon.com/512/3909/3909444.png")),
        //                     title: Text("Hindi"),
        //                     trailing: Text("Free"),
        //                   ),
        //                   ListTile(
        //                     onTap: () {
        //                       language = 'en';
        //                       Navigator.pop(context);
        //                     },
        //                     leading: CircleAvatar(
        //                         backgroundImage: NetworkImage(
        //                             "https://cdn-icons-png.flaticon.com/512/3909/3909383.png")),
        //                     title: Text("English"),
        //                     trailing: Text("Free"),
        //                   ),
        //                   ListTile(
        //                     onTap: () {
        //                       language = 'bn';
        //                       Navigator.pop(context);
        //                     },
        //                     leading: CircleAvatar(
        //                         backgroundImage: NetworkImage(
        //                       "https://icons.iconarchive.com/icons/custom-icon-design/round-world-flags/512/Bangladesh-icon.png",
        //                     )),
        //                     title: Text("Bengali"),
        //                     trailing: Text("Free"),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //     icon: Image.asset(
        //       "lib/images/belgium.png",
        //     ),
        //   )
        // ],
        actions: [
          Container(
              margin: EdgeInsets.only(right: 15),
              child: Center(
                  child: Text(
                "${widget.targetUser.countryFlag!}",
                style: TextStyle(fontSize: 27),
              )))
        ],
      ),
      body: SafeArea(
          child: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage(
        //     "lib/images/background.jpg",
        //   ),
        //   fit: BoxFit.cover,
        // )),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            // currentMessage2 = currentMessage;
                            // if (currentMessage.sender == widget.userModel.uid) {
                            //   widget.chatroom.lastMessage = "sender";
                            // } else {
                            //   widget.chatroom.lastMessage = "recever";
                            // }

                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      margin: (currentMessage.sender ==
                                              widget.userModel.uid)
                                          ? EdgeInsets.only(
                                              top: 2, bottom: 2, left: 40)
                                          : EdgeInsets.only(
                                              top: 2, bottom: 2, right: 40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                      ),
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          UIHelper.showAlertDialogText(
                                              context,
                                              (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? currentMessage.trns_text
                                                      .toString()
                                                  : currentMessage.text
                                                      .toString());
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                (currentMessage.sender ==
                                                        widget.userModel.uid)
                                                    ? (currentMessage.text
                                                        .toString())
                                                    : (currentMessage.trns_text
                                                        .toString()),
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Please check your internet connection"),
                        );
                      } else {
                        return Center(
                          child: Text("Say hi to your friend"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[500],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Enter message", border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        sendmessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
