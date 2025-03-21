import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/course_model.dart';

class CourseProvider with ChangeNotifier {
  List<CourseModel> _courses = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<CourseModel> get courses => _courses;

  Future<void> getCourses() async {
    try {
      var snapshot = await db.collection('courses').get();
      _courses = snapshot.docs.map((doc) => CourseModel.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  Future<void> addCourse(CourseModel course) async {
    try {
      await db.collection('courses').doc(course.id).set(course.toMap());
      await getCourses();
    } catch (e) {
      print("Error adding course: $e");
    }
  }

  List<CourseModel> getPopularCourses() {
    return List.from(_courses)..sort((a, b) => b.studentCount.compareTo(a.studentCount));
  }
}
