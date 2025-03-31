class StudentModel {
  String id;
  String name;
  String email;
  String phone;
  String gender;
  // List<String> enrolledCourseIds;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender
    // required this.enrolledCourseIds,
  });

  // factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
  //   return StudentModel(
  //     id: id,
  //     name: map['name'] ?? '',
  //     email: map['email'] ?? '',
  //     phone: map['phone'] ?? '',
  //     enrolledCourseIds: List<String>.from(map['enrolled_course_ids'] ?? []),
  //   );
  // }
  //
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'email': email,
  //     'phone': phone,
  //     'enrolled_course_ids': enrolledCourseIds,
  //   };
  // }
}
