// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';
// import 'package:lifeblood/chat_page/chat_screen.dart';
// import 'package:lifeblood/zzz/messaging/chat_screen.dart';
// import 'package:lifeblood/registration/recipient.dart';

// class RouteRequest extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   const RouteRequest({super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<RouteRequest> createState() => _RouteRequestState();
// }

// class _RouteRequestState extends State<RouteRequest> {
//   late Stream<QuerySnapshot> recepientStream;

//   @override
//   void initState() {
//     // TODO: implement initState
//     recepientStream =
//         FirebaseFirestore.instance.collection("askblood").snapshots();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Recepient List"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: recepientStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           } else {
//             final recepients = snapshot.data!.docs;
//             return ListView.builder(
//                 itemCount: recepients.length,
//                 itemBuilder: (context, index) {
//                   final recepient =
//                       recepients[index].data() as Map<String, dynamic>;
//                   final name = recepient["name"];
//                   final phone = recepient["phone"];
//                   final bloodType = recepient["bloodtype"];
//                   final address = recepient["address"];

//                   final String profilePic = widget.userModel.profilepic ?? "";

//                   return Container(
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       border: Border.all(),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 100,
//                           height: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: NetworkImage(profilePic),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 // Spacer(),
//                                 Text(
//                                   '$name',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(
//                                   width: 70,
//                                 ),
//                                 Text(
//                                   '$bloodType',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'Phone: $phone',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             Text(
//                               'Location: $address',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 Navigator.push(context,
//                                 MaterialPageRoute(builder: (context){
//                                  return ChatPage(userModel: widget.userModel,firebaseUser:widget.firebaseUser ,);
//                                 }));
//                               },
//                               icon: Icon(IconlyBroken.chat),
//                               iconSize: 30,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 // Navigator.push(context,
//                                 //     MaterialPageRoute(builder: (context) {
//                                 //    // Navigate to BloodRequestPage
//                                 // }));
//                               },
//                               icon: Icon(IconlyBold.send),
//                               iconSize: 30,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: StreamBuilder<QuerySnapshot>(
//           stream: recepientStream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final count = snapshot.data!.docs.length;
//               return Text('$count');
//             }
//             return Text('0');
//           },
//         ),
//       ),
//     );
//   }
// }
