import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/practice/edit_user.dart'; // Import your UserModel class

class UserProfilePage extends StatelessWidget {
  final UserModel user; // Pass the user information to this page

  UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              // CircleAvatar(
              //   radius: 80,
              //   backgroundImage: NetworkImage(user.profilepic!),
              // ),
              // SizedBox(height: 20),
              // Text(
              //   'Hello ${user.fullname}!',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 10),
              // Text(
              //   'Email: ${user.email}',
              //   style: TextStyle(fontSize: 18),
              // ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(user.profilepic!),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.fullname!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                user.email!,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow.withOpacity(0.1),
                  ),
                  child: Icon(Icons.settings),
                ),
                title: Text("Settings"),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(Icons.arrow_right_outlined),
                ),
              ),

              ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow.withOpacity(0.1),
                  ),
                  child: Icon(Icons.notifications),
                ),
                title: Text("Notifications"),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(Icons.arrow_right_outlined),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow.withOpacity(0.1),
                  ),
                  child: Icon(Icons.info_outline_rounded),
                ),
                title: Text("Information"),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(Icons.arrow_right_outlined),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow.withOpacity(0.1),
                  ),
                  child: Icon(Icons.logout),
                ),
                title: Text("Log Out"),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(Icons.arrow_right_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
