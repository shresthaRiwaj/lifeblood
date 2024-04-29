import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/blood_registration/edit_donor.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/chat_screen.dart';
import 'package:lifeblood/registration/recipient.dart';

class AdminSideDonor extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final bool isVerified;
  AdminSideDonor(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.isVerified})
      : super(key: key);

  @override
  State<AdminSideDonor> createState() => _ShowDonorListState();
}

class _ShowDonorListState extends State<AdminSideDonor> {
  late Stream<QuerySnapshot> verifiedDonorStream;
  late Stream<QuerySnapshot> unverifiedDonorStream;

  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    verifiedDonorStream = FirebaseFirestore.instance
        .collection("donors")
        .where("verified", isEqualTo: true)
        .snapshots();
    unverifiedDonorStream = FirebaseFirestore.instance
        .collection("donors")
        .where("verified", isEqualTo: false)
        .snapshots();
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
          content: Text("Donor Deleted"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donor List'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Verified'),
              Tab(text: 'Unverified'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDonorList(verifiedDonorStream),
            _buildDonorList(unverifiedDonorStream),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorList(Stream<QuerySnapshot> donorStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: donorStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final donors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index].data() as Map<String, dynamic>;
              final donorid = donors[index].id;
              final String name = donor['name'];
              final String bloodType = donor['bloodtype'];
              final String phone = donor['phone'];
              final String address = donor['address'];
              final String email = donor['email'];

              final String profilePic = widget.userModel.profilepic ?? '';

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
                            Text(
                              '$name',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            Text(
                              '$bloodType',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 12),
                        ),
                        if (isCurrentUser)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditDonorPage(
                                        name: name,
                                        email: email,
                                        phone: phone,
                                        address: address,
                                        selectedBloodType: bloodType,
                                        id: donorid);
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
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BloodRequestPage();
                              }));
                            },
                            icon: Icon(IconlyBold.send),
                            iconSize: 30,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
