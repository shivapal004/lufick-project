import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  String id;
  String studentId;
  String courseId;
  DateTime enrollmentDate;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
  });
}
