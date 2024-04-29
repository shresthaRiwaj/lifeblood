import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood/chat_models/ChatRoomModel.dart';
import 'package:lifeblood/chat_models/MessageModel.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/main.dart';

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

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // send message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("Message sent succesfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    NetworkImage(widget.targetUser.profilepic.toString()),
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.targetUser.fullname.toString()),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
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
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              QuerySnapshot dataSnapshot =
                                  snapshot.data as QuerySnapshot;

                              return ListView.builder(
                                reverse: true,
                                itemCount: dataSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel currentMessage =
                                      MessageModel.fromMap(
                                          dataSnapshot.docs[index].data()
                                              as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            color: (currentMessage.sender ==
                                                    widget.userModel.uid)
                                                ? Colors.grey
                                                : Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          currentMessage.text.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text("Error occured, check ur connection."),
                              );
                            } else {
                              return Center(
                                child: Text("Say hi"),
                              );
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(Icons.send),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
