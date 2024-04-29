import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/admin/admin_navbar.dart';
import 'package:lifeblood/admin/show%20_donor_list.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/feedback/show_feedback.dart';
import 'package:lifeblood/home_page/donation_event.dart';
import 'package:lifeblood/home_page/eligibility.dart';
import 'package:lifeblood/home_page/fetch_donor.dart';
import 'package:lifeblood/home_page/fetch_recipient.dart';

class AdminHomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AdminHomePage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text("LifeBlood"),
          centerTitle: true,
        ),
        drawer: AdminNavBar(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Hello, ${widget.userModel.fullname}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Welcome to LifeBlood',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Use the DonorList widget here
              FetchingDonorList(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              ),
              SizedBox(height: 20),
              FetchingRecipientList(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
              SizedBox(
                height: 15,
              ),
              EligibilityCriteria(),
              SizedBox(
                height: 20,
              ),
              // FeedbackForm(),
              UpcomingEvents(),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShowFeedback();
                  }));
                },
                icon: Icon(IconlyBroken.show),
                label: Text(
                  "Show Feedback",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
