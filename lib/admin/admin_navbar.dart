import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/admin/admin_list.dart';
import 'package:lifeblood/admin/adminpage.dart';
import 'package:lifeblood/admin/show%20_donor_list.dart';
import 'package:lifeblood/admin/userlist.dart';
import 'package:lifeblood/admintry/mappp.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/chat_screen.dart';
import 'package:lifeblood/maps/search_bar.dart';
import 'package:lifeblood/screens/login_screen.dart';

class AdminNavBar extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AdminNavBar(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can show a loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No data found');
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Drawer(
          backgroundColor: Colors.grey[300],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userData['fullname']),
                accountEmail: Text(userData['email']),
                currentAccountPicture: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(userData['profilepic']),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                    image: AssetImage("assets/blood3.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Verification"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminPanelPage();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline_outlined),
                title: Text("Chats"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatPage(
                      userModel: userModel,
                      firebaseUser: firebaseUser,
                    );
                  }));
                },
              ),

              ListTile(
                leading: Icon(IconlyBroken.user_2),
                title: Text("User List"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminPage();
                  }));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(IconlyBroken.profile),
                title: Text("Verified"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminSideDonor(
                      userModel: userModel,
                      firebaseUser: firebaseUser,
                      isVerified: true,
                    );
                  }));
                },
                trailing: ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LocationPageSearch();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app_rounded),
                title: Text("Log Out"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
              ),

              // Add other list items in the drawer
            ],
          ),
        );
      },
    );
  }
}
