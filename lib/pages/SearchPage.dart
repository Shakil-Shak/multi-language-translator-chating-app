import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/main.dart';
import 'package:multi_language_firebase_chat_app/models/ChatRoomModel.dart';
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:multi_language_firebase_chat_app/pages/ChatRoomPage.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage1: "",
          lastMessage2: "",
          lastMessageUid: "",
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true,
          });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New chat room created!!");
    }
    return chatRoom;
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
        backgroundColor: Colors.grey[800],
        title: Text("Search"),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: "Email Address"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Search"),
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorsModel.orangeLightColors,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  textStyle: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: searchController.text)
                    .where("email", isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatRoomModel =
                                await getChatRoomModel(searchUser);
                            if (chatRoomModel != null) {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoomPage(
                                  targetUser: searchUser,
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                  chatroom: chatRoomModel,
                                );
                              }));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchUser.profilepic!),
                          ),
                          title: Text(searchUser.firstname!),
                          subtitle: Text(
                              "${searchUser.countryName!} ${searchUser.countryFlag}"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return Text("No result found");
                      }
                    } else if (snapshot.hasError) {
                      return Text("An error occured!!");
                    } else {
                      return Text("No result found");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      )),
    );
  }
}
