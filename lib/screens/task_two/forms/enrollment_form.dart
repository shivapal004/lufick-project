import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/enrollment_provider.dart';

class EnrollmentForm extends StatefulWidget {
  const EnrollmentForm({super.key});

  @override
  State<EnrollmentForm> createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<EnrollmentForm> {
  late String selectedStudent;
  late String selectedCourse;
  DateTime enrollmentDate = DateTime.now();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Enroll Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField(
                  items: snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem(
                        value: doc.id, child: Text(doc['name']));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedStudent = val!),
                  decoration:
                      const InputDecoration(labelText: "Select Student"),
                );
              },
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField(
                  items: snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem(
                        value: doc.id, child: Text(doc['title']));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedCourse = val!),
                  decoration: const InputDecoration(labelText: "Select Course"),
                );
              },
            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              dateLabelText: "Enrollment Date",
              initialValue: enrollmentDate.toIso8601String(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (val) {
                setState(() {
                  enrollmentDate = DateTime.parse(val);
                });
              },
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Select a start date';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async{
                      await enrollmentProvider.addEnrollments(
                          student: selectedStudent,
                          course: selectedCourse,
                          enrollmentDate: enrollmentDate,
                      context: context);
                    },
                    child: const Text("Enroll Student"))
          ],
        ),
      ),
    );
  }
}
