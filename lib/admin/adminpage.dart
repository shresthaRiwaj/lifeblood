import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood/admin/admin_list.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Verified'),
              Tab(text: 'Unverified'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDonorsList(true), // Verified donors
            _buildDonorsList(false), // Unverified donors
          ],
        ),
      ),
    );
  }

  Widget _buildDonorsList(bool isVerified) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('donors')
          .where('verified', isEqualTo: isVerified)
          .snapshots(),
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
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Name: ${data['name']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Email: ${data['email']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Blood Type: ${data['bloodtype']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Blood Certificate:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          if (data['certificate_photo'] != null)
                            FractionallySizedBox(
                              widthFactor:
                                  0.4, // Set the width to 40% of the screen width
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(data['certificate_photo']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: data['verified']
                          ? null
                          : IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                _verifyDonor(doc.id);
                              },
                            ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Navigate to the DonorListPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonorListPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _verifyDonor(String donorId) {
    FirebaseFirestore.instance.collection('donors').doc(donorId).update({
      'verified': true,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donor verified successfully'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to verify donor: $error'),
        ),
      );
    });
  }
}
