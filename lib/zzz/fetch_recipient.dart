// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';
// // import 'package:lifeblood/nav/show_recipient.dart';
// import 'package:lifeblood/practice/route_reques.dart';

// class FetchingRecipientList extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   const FetchingRecipientList({
//     Key? key,
//     required this.userModel,
//     required this.firebaseUser,
//   }) : super(key: key);

//   @override
//   State<FetchingRecipientList> createState() => _FetchingRecipientListState();
// }

// class _FetchingRecipientListState extends State<FetchingRecipientList> {
//   bool showAll = false;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("askblood").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         var recipients = snapshot.data!.docs;
//         List<Widget> recipientTiles = [];

//         // Show only one recipient initially
//         int recipientCountToShow = showAll ? recipients.length : 1;

//         for (var i = 0; i < recipientCountToShow; i++) {
//           var recipientData = recipients[i].data() as Map<String, dynamic>;
//           recipientTiles.add(
//             ListTile(
//               leading: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(widget.userModel.profilepic ?? ""),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Name: ${recipientData['name']}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Blood Type: ${recipientData["bloodtype"]}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Phone: ${recipientData["phone"]}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Location: ${recipientData['address']}',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return Container(
//           margin: EdgeInsets.all(10),
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border.all(),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 'Recipients',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 2.0),
//               ...recipientTiles,
//               SizedBox(height: 8.0),
//               if (!showAll)
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RouteRequest(
//                           firebaseUser: widget.firebaseUser,
//                           userModel: widget.userModel,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'See All',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
