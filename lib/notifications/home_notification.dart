import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood/notifications/notification_services.dart';

class HomeNotification extends StatefulWidget {
  const HomeNotification({super.key});

  @override
  State<HomeNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<HomeNotification> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("device token");
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
