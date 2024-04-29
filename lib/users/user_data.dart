// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:lifeblood/chat_models/UserModel.dart';

// class UserProvider  extends ChangeNotifier{
//   late UserModel _user;

//   UserModel get user => _user;

//   Future <void> fetchuserData() async{
//     final currentuser = FirebaseAuth.instance.currentUser;
//     if(currentuser!=null){
//       final userData = await FirebaseFirestore.instance
//       .collection("users").doc(currentuser.uid).get();

//       _user = UserModel(
//         email: userData['email'],
//         profilepic: userData['profilepic'],
//       );
//       notifyListeners();
//     }
//   }
// }