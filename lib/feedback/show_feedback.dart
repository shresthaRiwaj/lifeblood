import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowFeedback extends StatefulWidget {

  const ShowFeedback({super.key});

  @override
  State<ShowFeedback> createState() => _ShowFeedbackState();
}

class _ShowFeedbackState extends State<ShowFeedback> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Feedback"),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("feedback")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      
                      return Text("No feedback at the moment");
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Feedback",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                var feedbackData =
                                    snapshot.data!.docs[index].data();
                                if (feedbackData is Map<String, dynamic> &&
                                    feedbackData.containsKey("feedback")) {
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      title:
                                          Text(feedbackData['feedback'] ?? ""),
                                      subtitle: Text(
                                          "Timestamp: ${DateTime.fromMicrosecondsSinceEpoch(feedbackData['timestamp'].millisecondsSinceEpoch)}"),
                                    ),
                                  );
                                } else {
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      title: Text("No feedback"),
                                      subtitle: Text("Timestamp none"),
                                    ),
                                  );
                                }
                              } else {
                                return SizedBox();
                              }
                            }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
