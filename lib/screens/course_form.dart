import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController instructorController = TextEditingController();

  void addCourse() async {
    FirebaseFirestore.instance.collection('courses').add({
      'title': titleController.text,
      'category': categoryController.text,
      'instructor': instructorController.text,
      'start_date': Timestamp.now(),
      'end_date': Timestamp.now(),
      // 'student_count': 0,
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Course Title")),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Category")),
            TextField(controller: instructorController, decoration: const InputDecoration(labelText: "Instructor")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addCourse, child: const Text("Add Course"))
          ],
        ),
      ),
    );
  }
}
