import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class BloodRequestPage extends StatefulWidget {
  const BloodRequestPage({Key? key}) : super(key: key);

  @override
  _BloodRequestPageState createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedBloodType;
  String? selectedQuantityUnit;
  bool _isLoading = false;
  bool bloodTypeInput = false;

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    selectedBloodType = null;
    selectedQuantityUnit = null;
    super.dispose();
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("blood_requests").add({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "blood_type": selectedBloodType,
          "quantity": "${quantityController.text.trim()} $selectedQuantityUnit",
          "location": locationController.text.trim(),
          "description": descriptionController.text.trim(),
          "timestamp": Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Blood request submitted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit blood request"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Request Blood"),
          centerTitle: true,
          backgroundColor: Colors.red[700],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bgimg.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(12),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: "Your Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: phoneController,
                            decoration:
                                InputDecoration(labelText: "Phone Number"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration:
                                InputDecoration(labelText: "Your Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedBloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypeInput = true;
                                selectedBloodType = value;
                              });
                            },
                            items: [
                              'A+',
                              'A-',
                              'B+',
                              'B-',
                              'AB+',
                              'AB-',
                              'O+',
                              'O-'
                            ].map((bloodType) {
                              return DropdownMenuItem<String>(
                                value: bloodType,
                                child: Text(bloodType),
                              );
                            }).toList(),
                            decoration:
                                InputDecoration(labelText: "Blood Type"),
                          ),
                          SizedBox(height: 10),
                          Row(
                            
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: quantityController,
                                  
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: "Quantity"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter quantity";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: selectedQuantityUnit,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedQuantityUnit = value;
                                    });
                                  },
                                  items: ['ml', 'l'].map((unit) {
                                    return DropdownMenuItem<String>(
                                      value: unit,
                                      child: Text(unit),
                                    );
                                  }).toList(),
                                  decoration:
                                      InputDecoration(labelText: "Unit"),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: locationController,
                            decoration: InputDecoration(labelText: "Location"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter location";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration:
                                InputDecoration(labelText: "Description"),
                            maxLines: 3,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _submitRequest,
                            icon: Icon(IconlyBold.send),
                            label: Text("Submit Request"),
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
