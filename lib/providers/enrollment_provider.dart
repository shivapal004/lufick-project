import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/enrollment_model.dart';

class EnrollmentProvider with ChangeNotifier {
  List<EnrollmentModel> _enrollments = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<EnrollmentModel> get enrollments => _enrollments;

  Future<void> getEnrollments() async {
    try {
      var snapshot = await db.collection('enrollments').get();
      _enrollments = snapshot.docs.map((doc) => EnrollmentModel.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching enrollments: $e");
    }
  }

  Future<void> addEnrollment(EnrollmentModel enrollment) async {
    try {
      await db.collection('enrollments').doc(enrollment.id).set(enrollment.toMap());
      await getEnrollments();
    } catch (e) {
      print("Error adding enrollment: $e");
    }
  }
}
