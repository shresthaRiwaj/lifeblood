import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifeblood/chat_models/UIHelper.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:lifeblood/home_page/home_page.dart';
import 'package:lifeblood/zzz/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File? imageFile;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  Future<void> selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  Future<void> cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 35);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a Photo"),
                ),
              ],
            ),
          );
        });
  }

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String fullname = fullNameController.text.trim();

    if (email == "" ||
        password == "" ||
        confirmPassword == "" ||
        fullname == "" ||
        imageFile == null) {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Fill all the form");
    } else if (password != confirmPassword) {
      UIHelper.showAlertDialog(
          context, "Incorrect password", "Check your password again");
    } else {
      signUp(email, password, fullname);
    }
  }

  Future<void> signUp(String email, String password, String fullname) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, 'Signing Up');

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "Error Occurred", ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: fullname,
        profilepic: "",
      );

      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(uid)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String? imageUrl = await snapshot.ref.getDownloadURL();
      newUser.profilepic = imageUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New User Created!!!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage(
            userModel: newUser,
            firebaseUser: credential!.user!,
          );
        }));
      });
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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[350],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Text(
                  //   "LifeBlood",
                  //   style: TextStyle(
                  //     color: Colors.redAccent,
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showPhotoOptions();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      child: (imageFile == null)
                          ? Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
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
                    height: 10,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                      child: Text("Sign Up"),
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
                "Already have an account?",
                style: TextStyle(fontSize: 18),
              ),
              CupertinoButton(
                  child: Text(
                    "Log In",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
