// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   static Future<void> sendNotificationToAllUsers(String bloodRequestDescription) async {
//     // Retrieve all registered users from Firestore
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('users').get();
    
//     // Initialize Firebase Messaging
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     // Loop through each registered user
//     querySnapshot.docs.forEach((DocumentSnapshot document) async {
//       String token = document['deviceToken']; // Assuming you store device tokens in 'deviceToken' field

//       // Construct the notification message
//       RemoteMessage notificationMessage = RemoteMessage(
//         data: {
//           'title': 'New Blood Request!',
//           'body': 'A new blood request has been submitted: $bloodRequestDescription',
//         },
//       );

//       // Send the notification to the specific token
//       await messaging.send(
//         // Specify the recipient token
//         recipient: token,
//         // Pass the notification message
//         message: notificationMessage,
//       );
//     });
//   }
// }
