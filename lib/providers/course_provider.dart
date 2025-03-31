import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../models/course_model.dart';
import '../widgets/global_methods.dart';

class CourseProvider with ChangeNotifier {
  List<CourseModel> _courses = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<CourseModel> get courses => _courses;

  Future<void> getCourses() async {
    try {
      QuerySnapshot courseSnapshot = await db.collection('courses').get();
      List<CourseModel> loadedCourses = [];

      for (var doc in courseSnapshot.docs) {
        String courseId = doc.id;

        QuerySnapshot enrollmentsSnapshot = await db
            .collection('enrollments')
            .where('course', isEqualTo: courseId)
            .get();
        int studentCount = enrollmentsSnapshot.docs.length;

        CourseModel course = CourseModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);

        course.studentCount = studentCount;
        loadedCourses.add(course);
      }

      loadedCourses.sort((a, b) => b.studentCount.compareTo(a.studentCount));

      _courses = loadedCourses;
      notifyListeners();
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  Future<void> addCourses(
      {required String title,
        required String category,
        required String instructor,
        required DateTime startDate,
        required DateTime endDate,
        required BuildContext context}) async {
    final uuid = const Uuid().v4();
    try {
      await db.collection('courses').doc(uuid).set({
        'id': uuid,
        'title': title,
        'category': category,
        'instructor': instructor,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String()
      });
      await Fluttertoast.showToast(
        msg: "Course details added",
        toastLength: Toast.LENGTH_LONG,
      );
      await getCourses();
      notifyListeners();
    } catch (error) {
      GlobalMethods.errorDialog(msg: error.toString(), context: context);
    }
  }

  List<CourseModel> getPopularCourses() {
    return List.from(_courses)
      ..sort((a, b) => b.studentCount.compareTo(a.studentCount));
  }
}
