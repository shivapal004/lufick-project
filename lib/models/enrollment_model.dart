import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  String id;
  String studentId;
  String courseId;
  DateTime enrollmentDate;
  String status;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
    required this.status,
  });

  factory EnrollmentModel.fromMap(Map<String, dynamic> map, String id) {
    return EnrollmentModel(
      id: id,
      studentId: map['studentId'] ?? '',
      courseId: map['courseId'] ?? '',
      enrollmentDate:
          (map['enrollmentDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'enrollmentDate': Timestamp.fromDate(enrollmentDate),
      'status': status,
    };
  }
}
