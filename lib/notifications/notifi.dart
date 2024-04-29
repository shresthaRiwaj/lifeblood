import 'package:flutter/material.dart';

class NotificationScreens extends StatelessWidget {
  final String title;
  final String body;

  const NotificationScreens({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              body,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
