import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../models/enrollment_model.dart';
import '../widgets/global_methods.dart';

class EnrollmentProvider with ChangeNotifier {
  List<EnrollmentModel> _enrollments = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<EnrollmentModel> get enrollments => _enrollments;

  Future<void> getEnrollments() async {
    try {
      await FirebaseFirestore.instance
          .collection('enrollments')
          .get()
          .then((QuerySnapshot enrollmentSnapshot) {
        _enrollments = [];
        for (var element in enrollmentSnapshot.docs) {
          _enrollments.insert(
              0,
              EnrollmentModel(
                  id: element.get('id'),
                  studentId: element.get('student'),
                  courseId: element.get('course'),
                  enrollmentDate: DateTime.parse(element.get('enrollmentDate')),
                  // status: element.get('status')
              ));
        }
      });
      notifyListeners();
    } catch (e) {
      print("Error fetching enrollments: $e");
    }
  }

  Future<void> addEnrollments(
      {required String student,
      required String course,
      required DateTime enrollmentDate,
      required BuildContext context}) async {
    final uuid = const Uuid().v4();
    try {
      await db.collection('enrollments').doc(uuid).set({
        'id': uuid,
        'student': student,
        'course': course,
        'enrollmentDate': enrollmentDate.toIso8601String(),
      });
      await Fluttertoast.showToast(
        msg: "Course details added",
        toastLength: Toast.LENGTH_LONG,
      );
      await getEnrollments();
      notifyListeners();
    } catch (error) {
      GlobalMethods.errorDialog(msg: error.toString(), context: context);
    }
  }

  Future<List<Map<String, dynamic>>> getCoursesWithEnrolledStudents() async {
    List<Map<String, dynamic>> coursesWithStudents = [];

    QuerySnapshot coursesSnapshot = await db.collection('courses').get();

    for (var courseDoc in coursesSnapshot.docs) {
      String courseId = courseDoc.id;

      QuerySnapshot enrollmentsSnapshot = await db
          .collection('enrollments')
          .where('course', isEqualTo: courseId)
          .get();

      List<Map<String, dynamic>> studentsList = [];

      for (var enrollmentDoc in enrollmentsSnapshot.docs) {
        String studentId = enrollmentDoc['student'];

        DocumentSnapshot studentDoc =
            await db.collection('students').doc(studentId).get();

        if (studentDoc.exists) {
          studentsList.add(studentDoc.data() as Map<String, dynamic>);
        }
      }

      coursesWithStudents.add({
        'course': courseDoc.data(),
        'students': studentsList,
      });
    }

    return coursesWithStudents;
  }
}
