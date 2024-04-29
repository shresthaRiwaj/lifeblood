// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lifeblood/users/user_data.dart';
// import 'package:provider/provider.dart';

// class FetchData extends StatelessWidget {
//   const FetchData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Fetch Data"),
//       ),
//       body: Consumer<UserProvider>(builder: (context, userProvider, _) {
//         if (userProvider.user == null) {
//           userProvider.fetchuserData();
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Email:${userProvider.user.email}"),
//               userProvider.user!.profilepic != null
//                   ? Image.network(userProvider.user!.profilepic!)
//                   : SizedBox(),
//             ],
//           );
//         }
//       }),
//     );
//   }
// }
