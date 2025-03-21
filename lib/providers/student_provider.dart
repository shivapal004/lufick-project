import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../models/student_model.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<StudentModel> get students => _students;

  Future<void> getStudents() async {
    try {
      var snapshot = await db.collection('students').get();
      _students = snapshot.docs.map((doc) => StudentModel.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  Future<void> addStudents(StudentModel student) async {
    try {
      var docRef = await db.collection('students').add(student.toMap());
      student.id = docRef.id;
      await db.collection('students').doc(docRef.id).update(student.toMap());
      await getStudents();
      notifyListeners();
    } catch (e) {
      print("Error adding student: $e");
    }
  }
}
