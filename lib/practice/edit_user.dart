import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EditUserPage extends StatefulWidget {
  final String fullname;
  final String email;
  final String password;
  final String confirmPassword;
  final String id;

  const EditUserPage(
      {super.key,
      required this.fullname,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.id});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController fullnameController;
  // final bloodController = TextEditingController();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  final EdgeInsets inputPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 16);

  void editList() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.id)
            .update({
          "name": fullnameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "ConfirmPassword": confirmPasswordController.text.trim(),
        });
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to edit!!!"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fullnameController = TextEditingController(
      text: widget.fullname,
    );
    emailController = TextEditingController(
      text: widget.email,
    );
    passwordController = TextEditingController(
      text: widget.password,
    );
    confirmPasswordController = TextEditingController(
      text: widget.confirmPassword,
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          centerTitle: true,
          title: Text("Edit Your Info"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Hero(
                        tag: widget.id,
                        child: CircleAvatar(
                          radius: 60,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Fill in your details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: fullnameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.streetAddress,
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please confirm your password";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        return editList();
                      },
                      icon: Icon(IconlyBold.editSquare),
                      label: Text(
                        "Edit",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
