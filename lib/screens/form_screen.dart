import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;
  String? _profession;

  final List<String> _professions = [
    "Student",
    "Software Engineer",
    "Doctor",
    "Teacher",
    "Other"
  ];

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }
      try {
        await firebaseFirestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": _nameController.text,
          "phone": _phoneController.text,
          "email": user.email,
          "dob": _dobController.text,
          "gender": _gender ?? "Not specified",
          "profession": _profession ?? "Not specified",
          "address": _addressController.text,
          "photoUrl": user.photoURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data saved successfully!")),
        );

        setState(() {
          _nameController.clear();
          _phoneController.clear();
          _dobController.clear();
          _addressController.clear();
          _gender = null;
          _profession = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //name
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 10),

                //phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Enter phone no.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your phone number" : null,
                ),
                const SizedBox(height: 10),

                //dob
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: "Enter date of birth",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your date of birth" : null,
                ),
                const SizedBox(height: 10),

                //gender
                const Text("Select Gender", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Radio(
                      value: "Male",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    const Text("Male"),
                    Radio(
                      value: "Female",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    const Text("Female"),
                    Radio(
                      value: "Other",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    const Text("Other"),
                  ],
                ),
                const SizedBox(height: 12),

                //profession
                DropdownButtonFormField<String>(
                  value: _profession,
                  decoration: InputDecoration(
                    labelText: "Select profession",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                  items: _professions.map((String profession) {
                    return DropdownMenuItem<String>(
                      value: profession,
                      child: Text(profession),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _profession = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Profession is required" : null,
                ),
                const SizedBox(height: 12),

                //address
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Enter your address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Address is required" : null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: saveUserData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
