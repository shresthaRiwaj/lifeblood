import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController feedbackController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    feedbackController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feedback Form"),
          backgroundColor: Colors.blue,
        ),
        body: AlertDialog(
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: feedbackController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Write your review",
                filled: true,
              ),
              maxLines: 5,
              maxLength: 4500,
              textInputAction: TextInputAction.done,
              validator: (String? text) {
                if (text == null || text.isEmpty) {
                  return ("Write your reviews here");
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String message;

                  try {
                    final collection = await FirebaseFirestore.instance
                        .collection("feedback")
                        .doc()
                        .set({
                      "timestamp": FieldValue.serverTimestamp(),
                      "feedback": feedbackController.text,
                    });
                    message = "Feedback sent successfully";
                  } catch (_) {
                    message = "Error sending feedback";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
