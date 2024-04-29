import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood/admintry/mappp.dart';
import 'package:lifeblood/firebase_options.dart';
import 'package:lifeblood/maps/address.dart';
import 'package:lifeblood/maps/map_home_screen.dart';
import 'package:lifeblood/maps/new.dart';
import 'package:lifeblood/maps/search_bar.dart';
import 'package:lifeblood/notifications/home_notification.dart';
import 'package:lifeblood/zzz/home_page.dart';
import 'package:lifeblood/zzz/donor_page.dart';
import 'package:lifeblood/registration/recipient.dart';
import 'package:lifeblood/zzz/search_location.dart';
import 'package:lifeblood/zzz/tryHome.dart';
import 'package:lifeblood/screens/login_screen.dart';
import 'package:lifeblood/screens/signup_screen.dart';
import 'package:lifeblood/users/feedbackpage.dart';
import 'package:lifeblood/users/fetch_data.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
