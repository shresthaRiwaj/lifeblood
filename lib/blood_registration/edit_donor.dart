import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EditDonorPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String selectedBloodType;
  final String id;

  const EditDonorPage(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.selectedBloodType,
      required this.id});

  @override
  State<EditDonorPage> createState() => _EditDonorPageState();
}

class _EditDonorPageState extends State<EditDonorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  // final bloodController = TextEditingController();
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  String? selectedBloodType;
  bool bloodTypeInput = false;
  final EdgeInsets inputPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 16);

  void editList() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection("donors")
            .doc(widget.id)
            .update({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "address": addressController.text.trim(),
          "bloodtype": selectedBloodType,
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
    nameController = TextEditingController(
      text: widget.name,
    );
    phoneController = TextEditingController(
      text: widget.phone,
    );
    emailController = TextEditingController(
      text: widget.email,
    );
    addressController = TextEditingController(
      text: widget.address,
    );
    selectedBloodType = widget.selectedBloodType;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
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
          title: Text("Edit Your Info"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bgimg.jpeg"), fit: BoxFit.cover),
          ),
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
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedBloodType,
                      onChanged: (value) {
                        setState(() {
                          // bloodTypeInput = true;
                          selectedBloodType = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                    SizedBox(
                      height: 20,
                    ),
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
