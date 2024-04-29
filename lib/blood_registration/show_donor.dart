import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood/blood_registration/edit_donor.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/chat_screen.dart';
import 'package:lifeblood/registration/edit_donor.dart';
import 'package:lifeblood/registration/recipient.dart';

class ShowDonorList extends StatefulWidget {
  final UserModel user;
  final User firebaseUser;
  ShowDonorList({Key? key, required this.user, required this.firebaseUser})
      : super(key: key);

  @override
  State<ShowDonorList> createState() => _ShowDonorListState();
}

class _ShowDonorListState extends State<ShowDonorList> {
  late Stream<QuerySnapshot> donorStream;

  String? currentUserEmail;

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
        donorStream = FirebaseFirestore.instance
            .collection("donors")
            .where("verified", isEqualTo: true) // Only verified donors
            .snapshots();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Donor's List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                final String certificatePhotoUrl =
                    donor['certificate_photo'] ?? "";

                final String profilePic = widget.user.profilepic ?? '';

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
                            style: TextStyle(fontSize: 15),
                          ),
                          if (certificatePhotoUrl.isNotEmpty)
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Blood Certificate',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            5), // Add some spacing between the text and image
                                    Container(
                                      height: 100,
                                      width: 150, // Adjust the width as needed
                                      child: Image.network(certificatePhotoUrl),
                                    ),
                                  ],
                                ),
                              ],
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
                                        id: donorid,
                                      );
                                    }));
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteDonor(donorid);
                                  },
                                  icon: Icon(Icons.delete),
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
                                    userModel: widget.user,
                                    firebaseUser: widget.firebaseUser,
                                  );
                                }));
                              },
                              icon: Icon(Icons.chat),
                            ),
                          if (!isCurrentUser)
                            IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BloodRequestPage();
                                }));
                              },
                              icon: Icon(Icons.send),
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
      ),
    );
  }
}
