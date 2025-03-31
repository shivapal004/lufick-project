import 'package:authentication_app/screens/task_two/details/students/edit_student_details_screen.dart';
import 'package:authentication_app/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/student_provider.dart';

class StudentDetails extends StatefulWidget {
  static const routeName = "/StudentDetailsScreen";

  const StudentDetails({
    super.key,
  });

  @override
  State<StudentDetails> createState() => _EditStudentDetailsState();
}

class _EditStudentDetailsState extends State<StudentDetails> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false).getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    final student =
        Provider.of<StudentProvider>(context).getStudentById(studentId);
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StudentProvider>(
            builder: (context, studentProvider, child) {
          studentProvider.getStudents();
          return Card(
            elevation: 3,
            color: Colors.orange.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Name: ${student.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Email: ${student.email}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("Phone: ${student.phone}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'Edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        )
                      ];
                    },
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditStudentDetailsScreen(
                                    student: student)));
                      } else if (value == 'Delete') {
                        _confirmDelete();
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _confirmDelete() {
    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    final student = Provider.of<StudentProvider>(context, listen: false)
        .getStudentById(studentId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {

                  final batch = FirebaseFirestore.instance.batch();
                  final enrollmentDocs = await db
                      .collection('enrollments')
                      .where('student', isEqualTo: student.id)
                      .get();
                  for (var doc in enrollmentDocs.docs) {
                    batch.delete(doc.reference);
                  }
                  batch.delete(db.collection('students').doc(student.id));
                  await batch.commit();

                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (error) {

                  GlobalMethods.errorDialog(
                      msg: error.toString(), context: context);

                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
