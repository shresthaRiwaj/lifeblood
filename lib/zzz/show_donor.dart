// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:iconly/iconly.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';
// import 'package:lifeblood/registration/recipient.dart';

// class ShowDonorList extends StatefulWidget {
//   final UserModel user;
//   ShowDonorList({Key? key, required this.user}) : super(key: key);

//   @override
//   State<ShowDonorList> createState() => _ShowDonorListState();
// }

// class _ShowDonorListState extends State<ShowDonorList> {
//   late Stream<QuerySnapshot> donorStream;

//   @override
//   void initState() {
//     super.initState();
//     donorStream = FirebaseFirestore.instance.collection("donors").snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: donorStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final donors = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: donors.length,
//               itemBuilder: (context, index) {
//                 final donor = donors[index].data() as Map<String, dynamic>;
//                 final String name = donor['name'];
//                 final String bloodType = donor['bloodtype'];
//                 final String phone = donor['phone'];
//                 final String address = donor['address'];

//                 final String profilePic = widget.user.profilepic ?? '';

//                 print('Profile Pic Type: ${profilePic.runtimeType}');
//                 return Container(
//                   margin: EdgeInsets.all(10),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: NetworkImage(profilePic),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       // Spacer(),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               // Spacer(),
//                               Text(
//                                 '$name',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: 70,
//                               ),
//                               Text(
//                                 '$bloodType',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             'Phone: $phone',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           Text(
//                             'Location: $address',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       Spacer(), // Push chat and send icons to the right
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: () {},
//                             icon: Icon(IconlyBroken.chat),
//                             iconSize: 30,
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) {
//                                 return BloodRequestPage(); // Navigate to BloodRequestPage
//                               }));
//                             },
//                             icon: Icon(IconlyBold.send),
//                             iconSize: 30,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
