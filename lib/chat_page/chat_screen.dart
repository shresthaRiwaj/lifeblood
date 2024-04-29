import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood/chat_models/ChatRoomModel.dart';
import 'package:lifeblood/chat_models/FirebaseHelper.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/ChatRoomPage.dart';
import 'package:lifeblood/chat_page/search_page.dart';
import 'package:lifeblood/zzz/messaging/search_page.dart';
import 'package:lifeblood/zzz/ChatRoomPage.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  // final String recepientEmail;

  const ChatPage(
      {super.key, required this.userModel, required this.firebaseUser, });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ChatApp"),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uid}", isEqualTo: true)
                // .orderBy("msgedon", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        Map<String, dynamic> participants =
                            chatRoomModel.participants!;
                        List<String> participantKeys =
                            participants.keys.toList();
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

                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                            targetUser: targetUser,
                                            chatroom: chatRoomModel,
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser);
                                      }));
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          targetUser.profilepic.toString()),
                                    ),
                                    title: Text(targetUser.fullname.toString()),
                                    subtitle: Text(
                                        chatRoomModel.lastMessage.toString()),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
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
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
