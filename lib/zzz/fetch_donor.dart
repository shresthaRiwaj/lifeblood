// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';
// import 'package:lifeblood/nav/show_donor.dart';

// class FetchingDonorList extends StatefulWidget {
//   final UserModel userModel;
//   const FetchingDonorList({
//     Key? key,
//     required this.userModel,
//   }) : super(key: key);

//   @override
//   State<FetchingDonorList> createState() => _FetchingDonorListState();
// }

// class _FetchingDonorListState extends State<FetchingDonorList> {
//   bool showAll = false;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("donors").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         var donors = snapshot.data!.docs;
//         List<Widget> donorTiles = [];

//         // Show only one donor initially
//         int donorCountToShow = showAll ? donors.length : 1;

//         for (var i = 0; i < donorCountToShow; i++) {
//           var donorData = donors[i].data() as Map<String, dynamic>;
//           donorTiles.add(
//             ListTile(
//               // contentPadding:
//               //     EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
//                   Row(
//                     children: [
//                       Text(
//                         'Name: ${donorData['name']}',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         '${donorData["bloodtype"]}',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Phone: ${donorData["phone"]}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Location: ${donorData['address']}',
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
//                 'Donors',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 2.0),
              
//               ...donorTiles,
//               SizedBox(height: 8.0),
//               if (!showAll)
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ShowDonorList(
//                           user: widget.userModel,
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
