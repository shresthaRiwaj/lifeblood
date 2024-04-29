// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';

// class RecepientHomePage extends StatefulWidget {
//   final UserModel userModel;
//   const RecepientHomePage({super.key, required this.userModel});

//   @override
//   State<RecepientHomePage> createState() => _RecepientHomePageState();
// }

// class _RecepientHomePageState extends State<RecepientHomePage> {
//   final recepientList =
//       FirebaseFirestore.instance.collection("blood_requests").snapshots();

//   String? currentUserEmail;
//   late User? user;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentUser();
//     final recepientStream =
//         FirebaseFirestore.instance.collection("users").snapshots();
//   }

//   void getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUserEmail = user.email;
//       });
//     }
//   }

//   void deleteRecepient(String id) async {
//     await FirebaseFirestore.instance
//         .collection("blood_requests")
//         .doc(id)
//         .delete();
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("recepient removed"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Lists"),
//         centerTitle: true,
//         backgroundColor: Colors.red[700],
//       ),
//       body: StreamBuilder(
//         stream: recepientList,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
//             if (documents.isEmpty) {
//               return Center(
//                 child: Text("No recepient at the moment"),
//               );
//             }
//             return ListView.builder(
//               itemCount: documents.length,
//               itemBuilder: (context, index) {
//                 final recepient =
//                     documents[index].data() as Map<String, dynamic>;
//                 final recepientid = documents[index].id;
//                 final String name = recepient["name"];
//                 final String blood_type = recepient["blood_type"];
//                 final String email = recepient["email"];
//                 final String quantity = recepient["quantity"];
//                 // final String profilePic = widget.userModel.profilepic ?? "";

//                 bool isCurrentUser = currentUserEmail == email;
//                 return ListTile(
//                   title: Text(name),
//                   subtitle: Text("$email, $blood_type, $quantity"),
//                   leading: Hero(
//                     tag: recepientid,
//                     child: CircleAvatar(
//                       radius: 30,
//                       // backgroundImage: NetworkImage(profilePic),
//                     ),
//                   ),
//                   trailing: isCurrentUser
//                       ? Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(IconlyBroken.edit),
//                               splashRadius: 24,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 deleteRecepient(recepientid);
//                               },
//                               icon: Icon(IconlyBroken.delete),
//                               splashRadius: 24,
//                             ),
//                           ],
//                         )
//                       : null,
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("Has an error"),
//             );
//           } else {
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
