import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood/admin/adminHomePage.dart';
import 'package:lifeblood/admin/adminpage.dart';
import 'package:lifeblood/admintry/bottom.dart';
import 'package:lifeblood/chat_models/UIHelper.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/home_page/home_page.dart';
// import 'package:lifeblood/pages/home_page.dart';
import 'package:lifeblood/screens/signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Missing Fields", "Fill up the form properly");
    } else if (email == "grayneon@gmail.com") {
      adminLogIn(email, password);
    } else {
      logIn(email, password);
    }
  }

  Future<void> logIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging in....");

    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      // closing loading
      Navigator.pop(context);

      // showing alert
      UIHelper.showAlertDialog(
          context, "Error Occurred", ex.message.toString());
      // print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // HomePage
      print("Log In Succesful!!!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(
            userModel: userModel,
            firebaseUser: credential!.user!,
          );
        }),
      );
    }
  }

  Future<void> adminLogIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging in....");

    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      // closing loading
      Navigator.pop(context);

      // showing alert
      UIHelper.showAlertDialog(
          context, "Error Occurred", ex.message.toString());
      // print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // HomePage
      print("Log In Succesful!!!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return AdminHomePage(
            userModel: userModel,
            firebaseUser: credential!.user!,
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "LifeBlood",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.grey[350],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                      child: Text("Log In"),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        checkValues();
                      }),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 18),
              ),
              CupertinoButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SignUpPage();
                      }),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
