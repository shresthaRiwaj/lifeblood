import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood/admintry/mappp.dart';
import 'package:lifeblood/articles/share_article.dart';
import 'package:lifeblood/blood_registration/route_reques.dart';
import 'package:lifeblood/blood_registration/show_donor.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/chat_page/chat_screen.dart';
import 'package:lifeblood/maps/search_bar.dart';
import 'package:lifeblood/notifications/notifi.dart';
import 'package:lifeblood/notifications/notification_screen.dart';
import 'package:lifeblood/users/feedbackpage.dart';
import 'package:lifeblood/users/user_feedback.dart';
import 'package:lifeblood/zzz/messaging/chat_screen.dart';
// import 'package:lifeblood/nav/show_donor.dart';
import 'package:lifeblood/zzz/ask_blood.dart';
import 'package:lifeblood/practice/practiceone.dart';
import 'package:lifeblood/zzz/route_reques.dart';
import 'package:lifeblood/registration/recipient.dart';
import 'package:lifeblood/screens/login_screen.dart';
import 'package:lifeblood/screens/loout_screen.dart';

class NavBarScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const NavBarScreen(
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
                leading: Icon(Icons.person),
                title: Text("Profile"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return UserProfilePage(user: userModel);
                    }),
                  );
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
                leading: Icon(Icons.share),
                title: Text("share"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ShareNavbar();
                    }),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Request"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RouteRequest(
                      firebaseUser: firebaseUser,
                      userModel: userModel,
                    ); // Navigate to BloodRequestPage
                  }));
                },
                trailing: ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 20,
                    height: 20,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('askblood')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final count = snapshot.data!.docs.length;
                          return Center(
                            child: Text(
                              "$count",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Notifications"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NotificationScreen();
                  }));
                },
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
                leading: Icon(Icons.feedback),
                title: Text("Feedback"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FeedbackForm();
                      });
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
