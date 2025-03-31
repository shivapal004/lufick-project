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
    this.studentCount = 0,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      instructor: map['instructor'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      studentCount: (map['studentCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'instructor': instructor,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'studentCount': studentCount,
    };
  }
}
