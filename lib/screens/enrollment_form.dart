import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enrollment_model.dart';
import '../providers/enrollment_provider.dart';

class EnrollmentForm extends StatefulWidget {
  const EnrollmentForm({super.key});

  @override
  State<EnrollmentForm> createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<EnrollmentForm> {
  String? selectedStudent;
  String? selectedCourse;
  bool isLoading = false;

  Future<void> enrollStudent() async {
    if (selectedStudent == null || selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both student and course")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await Provider.of<EnrollmentProvider>(context, listen: false).addEnrollment(
        EnrollmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          studentId: selectedStudent!,
          courseId: selectedCourse!,
          enrollmentDate: DateTime.now(),
          status: "Ongoing",
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error enrolling student: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enroll Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField(
                  items: snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem(value: doc.id, child: Text(doc['name']));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedStudent = val),
                  decoration: const InputDecoration(labelText: "Select Student"),
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField(
                  items: snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem(value: doc.id, child: Text(doc['title']));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedCourse = val),
                  decoration: const InputDecoration(labelText: "Select Course"),
                );
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: enrollStudent, child: const Text("Enroll Student"))
          ],
        ),
      ),
    );
  }
}
