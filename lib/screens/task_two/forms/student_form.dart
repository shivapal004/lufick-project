import 'package:authentication_app/services/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/student_provider.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedGender;

  void submitStudentDetails() async {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState!.save();

      try {
        await studentProvider.addStudents(
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            gender: selectedGender!,
            context: context);
        await studentProvider.getStudents();
      } catch (error) {
        GlobalMethods.errorDialog(msg: error.toString(), context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter name";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter email";
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter phone no.";
                    } else {
                      return null;
                    }
                  }),

              DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: "Gender"),
                  value: selectedGender,
                  items: ["Male", "Female", "Other"].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select gender" : null),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    submitStudentDetails();
                  },
                  child: const Text("Add Student")),
            ],
          ),
        ),
      ),
    );
  }
}
