import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackEntry extends StatelessWidget {
  final Map<String, dynamic> feedbackData;

  const FeedbackEntry({Key? key, required this.feedbackData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(feedbackData['userId'])
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              backgroundColor: Colors.grey, // Placeholder color while loading
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return CircleAvatar(
              backgroundColor: Colors.grey, // Placeholder color if error occurs
            );
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final profilePicUrl = userData['profilepic'] ?? '';
          return CircleAvatar(
            backgroundImage: NetworkImage(profilePicUrl),
          );
        },
      ),
      title: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(feedbackData['userId'])
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Text("Error loading data");
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['fullname'] ?? 'Unknown User';
          return Text(userName);
        },
      ),
      subtitle: Text(feedbackData['feedback']),
    );
  }
}
