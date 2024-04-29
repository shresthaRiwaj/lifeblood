import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListPage extends StatefulWidget {
  const DonorListPage({Key? key});

  @override
  State<DonorListPage> createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserEmail =
        'grayneon@gmail.com'; // Change this to your desired email
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == currentUserEmail) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Donor List'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('donors').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No donors to display'));
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data['profilepic'] ?? ''),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${data['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Email: ${data['email']}'),
                            Text('Blood Type: ${data['bloodtype']}'),
                            Text('Phone: ${data['phone']}'),
                            Text('Address: ${data['address']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Text('Access Denied'),
        ),
      );
    }
  }
}
