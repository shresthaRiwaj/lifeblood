import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifeblood/chat_models/UserModel.dart';
import 'package:iconly/iconly.dart';

class DonorPage extends StatefulWidget {
  final String loggedInUserEmail;
  const DonorPage({super.key, required this.loggedInUserEmail});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? selectedBloodType;
  bool bloodTypeInput = false;
  bool isVerified = false;
  File? certificatePhoto;
  final EdgeInsets inputPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 16);

  void donorRegister() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      if (email != widget.loggedInUserEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email does not match"),
          ),
        );
        return;
      }
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("donors")
          .where("email", isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You have already registered as a donor."),
          ),
        );
      } else {
        try {
          String certificatePhotoUrl = '';
          if (certificatePhoto != null) {
            // Upload certificate photo to Firebase Storage
            final ref = FirebaseStorage.instance
                .ref()
                .child('certificate_photos')
                .child(DateTime.now().toString() + '.jpg');
            await ref.putFile(certificatePhoto!);
            certificatePhotoUrl = await ref.getDownloadURL();
          }

          await FirebaseFirestore.instance.collection("donors").add({
            "name": nameController.text.trim(),
            "bloodtype": selectedBloodType,
            "phone": phoneController.text.trim(),
            "email": emailController.text.trim(),
            "address": addressController.text.trim(),
            "verified": isVerified,
            "certificate_photo": certificatePhotoUrl,
          });

          Navigator.pop(context);
        } on FirebaseException {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to register user."),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
    }
  }

  void _pickCertificatePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        certificatePhoto = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> bloodTypes = [
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-',
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          centerTitle: true,
          title: Text("Register as Donor"),
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
                    Text(
                      "Fill in your details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: nameController,
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
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedBloodType,
                      onChanged: (value) {
                        setState(() {
                          bloodTypeInput = true;
                          selectedBloodType = value;
                        });
                      },
                      validator: (value) {
                        if (!bloodTypeInput) {
                          return "Please select your blood type";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Blood Type",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: bloodTypes.map((bloodType) {
                        return DropdownMenuItem<String>(
                          value: bloodType,
                          child: Text(bloodType),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: phoneController,
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.streetAddress,
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your address";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Address",
                        contentPadding: inputPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Upload Certificate Photo',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _pickCertificatePhoto(),
                      icon: Icon(Icons.photo_camera),
                      label: Text('Select Photo'),
                    ),
                    SizedBox(height: 10),
                    certificatePhoto != null
                        ? Image.file(
                            certificatePhoto!,
                            height: 200,
                            width: 200,
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: donorRegister,
                      icon: Icon(IconlyBold.add_user),
                      label: Text(
                        "Register",
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
