import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood/admin/admin_list.dart';
// import 'donor_list_page.dart'; // Import your DonorListPage here

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Verified',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear),
            label: 'Unverified',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildDonorsList(true); // Verified donors
      case 1:
        return _buildDonorsList(false); // Unverified donors
      default:
        return Container();
    }
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
                      title: Text(data['name']),
                      subtitle: Text(data['email']),
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
