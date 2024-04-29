// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';
// import 'package:lifeblood/custom/donation_event.dart';
// import 'package:lifeblood/custom/eligibility.dart';
// import 'package:lifeblood/custom/fetch_donor.dart';
// import 'package:lifeblood/custom/fetch_recipient.dart';
// import 'package:lifeblood/nav/navbar.dart';
// import 'package:lifeblood/nav/show_donor.dart';
// import 'package:lifeblood/practice/ask_blood.dart';
// import 'package:lifeblood/registration/donor_page.dart';
// import 'package:lifeblood/registration/recepient_home.dart';
// import 'package:lifeblood/registration/tryHome.dart';
// import 'package:lifeblood/users/user_feedback.dart';

// class HomePage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const HomePage({
//     super.key,
//     required this.userModel,
//     required this.firebaseUser,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey[200],
//           title: Text("LifeBlood"),
//           centerTitle: true,
//         ),
//         drawer: NavBarScreen(
//             userModel: widget.userModel, firebaseUser: widget.firebaseUser),
//         backgroundColor: Colors.grey[200],
//         body: SingleChildScrollView(
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Hello, ${widget.userModel.fullname}",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 'Welcome to LifeBlood',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add onPressed functionality for the button
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return AskBlood(loggedInUserEmail: widget.userModel.email!);
//                   }));
//                 },
//                 child: Text('Ask Blood'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add onPressed functionality for the button
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return DonorPage(
//                         loggedInUserEmail: widget.userModel.email!);
//                   }));
//                 },
//                 child: Text('Donor Registration'),
//               ),
//               // SizedBox(height: 20.0),
//               // Text(
//               //   'Latest News',
//               //   style: TextStyle(
//               //     fontSize: 18.0,
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               // SizedBox(height: 8.0),
//               // Container(
//               //   padding: EdgeInsets.all(10),
//               //   child: Text(
//               //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus euismod justo ut velit rutrum, vitae vehicula sapien volutpat. Integer nec dui at mi finibus ullamcorper.',
//               //   ),
//               // ),
//               // SizedBox(height: 16.0),
//               // SizedBox(
//               //   height: 15,
//               // ),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     // Navigate to full news article
//               //   },
//               //   child: Text('Read More'),
//               // ),
//               // SizedBox(
//               //   height: 30,
//               // ),
//               // SizedBox(),
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       ElevatedButton(
//               //         onPressed: () {
//               //           // Add onPressed functionality for the button
//               //           Navigator.push(context,
//               //               MaterialPageRoute(builder: (context) {
//               //             return TryHomePage();
//               //           }));
//               //         },
//               //         child: Text('Donors'),
//               //       ),
//               //       // NewHomeDesign(user: widget.userModel),
//               //       SizedBox(height: 30.0),
//               //       GestureDetector(
//               //         onTap: () {
//               //           // Navigate to the page displaying the whole list
//               //           Navigator.push(context,
//               //               MaterialPageRoute(builder: (context) {
//               //             return ShowDonorList(
//               //               user: widget.userModel,
//               //             ); // Replace SeeAllDonorsPage with your actual page name
//               //           }));
//               //         },
//               //         child: Text(
//               //           'See All',
//               //           style: TextStyle(
//               //             decoration: TextDecoration.underline,
//               //             color: Colors.blue,
//               //           ),
//               //         ),
//               //       ),
//               //       ElevatedButton(
//               //         onPressed: () {
//               //           // Add onPressed functionality for the button
//               //           Navigator.push(context,
//               //               MaterialPageRoute(builder: (context) {
//               //             return AskBlood(
//               //                 loggedInUserEmail: widget.userModel.email!);
//               //           }));
//               //         },
//               //         child: Text('Recipient'),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: const EdgeInsets.all(20.0),
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       showDialog(
//               //         context: context,
//               //         builder: (context) => FeedbackForm(),
//               //       );
//               //     },
//               //     child: Text('Give Feedback'),
//               //   ),
//               // ),
//               SizedBox(
//                 height: 20,
//               ),
//               // Use the DonorList widget here
//               FetchingDonorList(
//                 userModel: widget.userModel,
//               ),
//               SizedBox(height: 20),
//               FetchingRecipientList(
//                   userModel: widget.userModel,
//                   firebaseUser: widget.firebaseUser),
//               SizedBox(
//                 height: 15,
//               ),
//               EligibilityCriteria(),
//               SizedBox(
//                 height: 20,
//               ),
//               // FeedbackForm(),
//               UpcomingEvents(),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
