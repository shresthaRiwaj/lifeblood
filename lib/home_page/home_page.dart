import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:lifeblood/blood_registration/ask_blood.dart';
import 'package:lifeblood/blood_registration/donor_page.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/feedback/show_feedback.dart';
import 'package:lifeblood/zzz/donation_event.dart';
import 'package:lifeblood/zzz/eligibility.dart';
import 'package:lifeblood/zzz/fetch_donor.dart';
import 'package:lifeblood/zzz/fetch_recipient.dart';
import 'package:lifeblood/home_page/donation_event.dart';
import 'package:lifeblood/home_page/eligibility.dart';
import 'package:lifeblood/home_page/fetch_donor.dart';
import 'package:lifeblood/home_page/fetch_recipient.dart';
import 'package:lifeblood/nav/navbar.dart';
// import 'package:lifeblood/nav/show_donor.dart';
import 'package:lifeblood/zzz/ask_blood.dart';
import 'package:lifeblood/zzz/donor_page.dart';
import 'package:lifeblood/zzz/recepient_home.dart';
import 'package:lifeblood/zzz/tryHome.dart';
import 'package:lifeblood/users/user_feedback.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        drawer: NavBarScreen(
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
              ElevatedButton(
                onPressed: () {
                  // Add onPressed functionality for the button
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AskBlood(loggedInUserEmail: widget.userModel.email!);
                  }));
                },
                child: Text('Ask Blood'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add onPressed functionality for the button
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DonorPage(
                        loggedInUserEmail: widget.userModel.email!);
                  }));
                },
                child: Text('Donor Registration'),
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
              // StreamBuilder(
              //   stream: FirebaseFirestore.instance
              //       .collection('feedback')
              //       .orderBy('timestamp', descending: true)
              //       .snapshots(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //     if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     }
              //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //       return Text('No feedback available');
              //     }
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Feedback:',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         SizedBox(height: 10),
              //         ListView.builder(
              //           shrinkWrap: true,
              //           itemCount: snapshot.data!.docs.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             if (snapshot.hasData &&
              //                 snapshot.data!.docs.isNotEmpty) {
              //               var feedbackData =
              //                   snapshot.data!.docs[index].data();
              //               if (feedbackData is Map<String, dynamic> &&
              //                   feedbackData.containsKey('feedback')) {
              //                 return ListTile(
              //                   title: Text(feedbackData['feedback'] ?? ""),
              //                   subtitle: Text(
              //                     'Timestamp: ${DateTime.fromMillisecondsSinceEpoch(feedbackData['timestamp'].millisecondsSinceEpoch)}',
              //                   ),
              //                 );
              //               } else {
              //                 return ListTile(
              //                   title: Text('Feedback data is missing'),
              //                   subtitle: Text("No timestamp available"),
              //                 );
              //               }
              //             }
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShowFeedback(
                    );
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
