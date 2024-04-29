import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/blood_registration/edit_donor.dart';
import 'package:lifeblood/blood_registration/show_donor.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/nav/navbar.dart';
import 'package:lifeblood/zzz/donor_page.dart';
import 'package:lifeblood/registration/edit_donor.dart';

class TryHomePage extends StatefulWidget {
  const TryHomePage({super.key});

  @override
  State<TryHomePage> createState() => _TryHomePageState();
}

class _TryHomePageState extends State<TryHomePage> {
  UserModel? userModel;
  final donorList = FirebaseFirestore.instance.collection("donors").snapshots();

  String? currentUserEmail;
  late User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  void deleteDonor(String id) async {
    await FirebaseFirestore.instance.collection("donors").doc(id).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Donor removed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register User"),
      ),
      body: StreamBuilder(
        stream: donorList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(
                child: Text(
                  "No donors yet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final donor = documents[index].data() as Map<String, dynamic>;
                final donorid = documents[index].id;
                final String name = donor["name"];
                final String email = donor["email"];
                final String phone = donor["phone"];
                final String address = donor["address"];
                final String bloodtype = donor["bloodtype"];

                // Check if the current user's email matches the donor's email
                bool isCurrentUser = currentUserEmail == email;

                return ListTile(
                  title: Text(name),
                  subtitle: Text("$phone \n $email \n Type: $bloodtype"),
                  // leading: Hero(
                  //   tag: donorid,
                  //   child: CircleAvatar(
                  //     radius: 30,
                  //   ),
                  // ),
                  trailing: isCurrentUser
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditDonorPage(
                                    name: name,
                                    phone: phone,
                                    email: email,
                                    address: address,
                                    selectedBloodType: bloodtype,
                                    id: donorid,
                                  );
                                }));
                              },
                              icon: Icon(IconlyBroken.edit),
                              splashRadius: 24,
                            ),
                            IconButton(
                              onPressed: () {
                                deleteDonor(donorid);
                              },
                              icon: Icon(IconlyBroken.delete),
                              splashRadius: 24,
                            ),
                          ],
                        )
                      : null, // If not the current user, show no trailing icons
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Has an error"),
            );
          } else {
            return CircularProgressIndicator.adaptive();
          }
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return DonorPage();
      //     }));
      //   },
      //   label: Text("Add Contact"),
      //   icon: Icon(IconlyBroken.document),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NavBarScreen(
              userModel: userModel!,
              firebaseUser: user!,
            );
          }));
        },
        label: Text("Nav"),
        icon: Icon(IconlyBroken.document),
      ),
    );
  }
}
