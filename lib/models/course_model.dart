import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String id;
  String title;
  String category;
  String instructor;
  DateTime startDate;
  DateTime endDate;
  int studentCount;

  CourseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.instructor,
    required this.startDate,
    required this.endDate,
    required this.studentCount,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      instructor: map['instructor'] ?? '',
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      studentCount: (map['studentCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'instructor': instructor,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'studentCount': studentCount,
    };
  }
}
