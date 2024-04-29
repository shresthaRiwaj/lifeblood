// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:iconly/iconly.dart';

// class AskBlood extends StatefulWidget {
//   final String loggedInUserEmail;
//   const AskBlood({super.key, required this.loggedInUserEmail});

//   @override
//   State<AskBlood> createState() => _AskBloodState();
// }

// class _AskBloodState extends State<AskBlood> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final quantityController = TextEditingController();
//   String? selectedBloodType;
//   final EdgeInsets inputPadding =
//       EdgeInsets.symmetric(vertical: 12, horizontal: 16);
//   String? selectedQuantityUnit;
//   bool bloodTypeInput = false;
//   bool quantityInputType = false;

//   void requestBlood() async {
//     if (_formKey.currentState!.validate()) {
//       String email = emailController.text.trim();
//       if (email != widget.loggedInUserEmail) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Email doesn't match"),
//           ),
//         );
//         return;
//       }
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection("askblood")
//           .where("email", isEqualTo: email)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("You have already requested"),
//           ),
//         );
//       } else {
//         print("Done");
//         try {
//           await FirebaseFirestore.instance.collection('askblood').add({
//             "name": nameController.text.trim(),
//             "phone": phoneController.text.trim(),
//             "email": emailController.text.trim(),
//             "address": addressController.text.trim(),
//             "descrption": descriptionController.text.trim(),
//             "bloodtype": selectedBloodType,
//             "quantity": selectedQuantityUnit,
//           });
//           if (mounted) {
//             Navigator.pop(context);
//           }
//         } on FirebaseException {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Failed to register"),
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     descriptionController.dispose();
//     selectedBloodType = null;
//     selectedQuantityUnit = null;
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     List<String> bloodTypes = [
//       'A+',
//       'A-',
//       'B+',
//       'B-',
//       'AB+',
//       'AB-',
//       'O+',
//       'O-',
//     ];
//     List<String> qunatityTypes = ['ml', 'l'];
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Request Blood"),
//           backgroundColor: Colors.red[700],
//         ),
//         body: Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/bgimg.jpeg"), fit: BoxFit.cover),
//           ),
//           child: ListView(
//             padding: EdgeInsets.all(12),
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Text(
//                       "Fill in your data",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: nameController,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Please enter your name";
//                         }
//                         return null;
//                       },
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Full Name",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     DropdownButtonFormField<String>(
//                       value: selectedBloodType,
//                       onChanged: (value) {
//                         setState(() {
//                           bloodTypeInput = true;
//                           selectedBloodType = value;
//                         });
//                       },
//                       validator: (value) {
//                         if (!bloodTypeInput) {
//                           return "Please select your blood type";
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         hintText: "Blood Type",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       items: bloodTypes.map((bloodType) {
//                         return DropdownMenuItem<String>(
//                           value: bloodType,
//                           child: Text(bloodType),
//                         );
//                       }).toList(),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: TextFormField(
//                             controller: quantityController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               labelText: "Quantity",
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please enter the needed qunatity";
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: DropdownButtonFormField<String>(
//                             value: selectedQuantityUnit,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedQuantityUnit = value;
//                               });
//                             },
//                             items: qunatityTypes.map((qunatityType) {
//                               return DropdownMenuItem<String>(
//                                 value: qunatityType,
//                                 child: Text(qunatityType),
//                               );
//                             }).toList(),
//                             decoration: InputDecoration(labelText: "Unit"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: emailController,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Please enter your email";
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.emailAddress,
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Email",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: phoneController,
//                       keyboardType: TextInputType.numberWithOptions(),
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Please enter your phone number";
//                         }
//                         return null;
//                       },
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Phone Number",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       keyboardType: TextInputType.streetAddress,
//                       controller: addressController,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Please enter your address";
//                         }
//                         return null;
//                       },
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Address",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       keyboardType: TextInputType.streetAddress,
//                       controller: descriptionController,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Please enter descrption";
//                         }
//                         return null;
//                       },
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                         hintText: "Descrption",
//                         contentPadding: inputPadding,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         return requestBlood();
//                       },
//                       icon: Icon(IconlyBroken.add_user),
//                       label: Text(
//                         "Submit",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
