// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/blood_registration/edit_recipient.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/chat_screen.dart';
import 'package:lifeblood/notifications/notifi.dart';
import 'package:lifeblood/notifications/notification_screen.dart';
import 'package:lifeblood/zzz/messaging/chat_screen.dart';
import 'package:lifeblood/registration/recipient.dart';

class RouteRequest extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const RouteRequest(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<RouteRequest> createState() => _RouteRequestState();
}

class _RouteRequestState extends State<RouteRequest> {
  late Stream<QuerySnapshot> recepientStream;

  String? currentUserEmail;

  @override
  void initState() {
    // TODO: implement initState
    recepientStream =
        FirebaseFirestore.instance.collection("askblood").snapshots();
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  void deleteRecipient(String id) async {
    await FirebaseFirestore.instance.collection("askblood").doc(id).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Recipient deleted"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recepient List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: recepientStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final recepients = snapshot.data!.docs;
            return ListView.builder(
                itemCount: recepients.length,
                itemBuilder: (context, index) {
                  final recepient =
                      recepients[index].data() as Map<String, dynamic>;
                  final recepientid = recepients[index].id;
                  final String name = recepient["name"];
                  final String phone = recepient["phone"];
                  final String bloodType = recepient["bloodtype"];
                  final String address = recepient["address"];
                  final String email = recepient["email"];
                  final String description = recepient["description"] ?? "";
                  final String quantity = recepient["quantity"] ?? "";
                  final String quantityType = recepient["quantityunit"] ?? "";

                  final String profilePic = widget.userModel.profilepic ?? "";

                  bool isCurrentUser = currentUserEmail == email;

                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(profilePic),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Spacer(),
                                Text(
                                  '$name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Text(
                                  '$bloodType',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'Phone: $phone',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Location: $address',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Email: $email',
                              style: TextStyle(fontSize: 13),
                            ),
                            if (isCurrentUser)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditRecipientPage(
                                                name: name,
                                                email: email,
                                                phone: phone,
                                                address: address,
                                                description: description,
                                                id: recepientid,
                                                quantity: quantity,
                                                selectedBloodType: bloodType,
                                                selectedQuantityUnit:
                                                    quantityType,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: Icon(IconlyBroken.edit),
                                      splashRadius: 24),
                                  IconButton(
                                    onPressed: () {
                                      deleteRecipient(recepientid);
                                    },
                                    icon: Icon(IconlyBroken.delete),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isCurrentUser)
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatPage(
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser,
                                      
                                    );
                                  }));
                                },
                                icon: Icon(IconlyBroken.chat),
                                iconSize: 30,
                              ),
                            if (!isCurrentUser)
                              IconButton(
                                onPressed: () {},
                                icon: Icon(IconlyBold.send),
                                iconSize: 30,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: StreamBuilder<QuerySnapshot>(
          stream: recepientStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final count = snapshot.data!.docs.length;
              return Text('$count');
            }
            return Text('0');
          },
        ),
      ),
    );
  }
}
