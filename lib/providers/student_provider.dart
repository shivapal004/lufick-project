import 'package:authentication_app/widgets/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../models/student_model.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<StudentModel> get students => _students;

  Future<void> getStudents() async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .get()
          .then((QuerySnapshot studentSnapshot) {
        _students = [];
        for (var element in studentSnapshot.docs) {
          _students.insert(
              0,
              StudentModel(
                  id: element.get('id'),
                  name: element.get('name'),
                  email: element.get('email'),
                  phone: element.get('phone'),
                  gender: element.get('gender')
                  // enrolledCourseIds: element.get('enrolledCourseIds')
              ));
        }
      });
      notifyListeners();
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  StudentModel getStudentById(String studentId) {
    return _students.firstWhere((element) => element.id == studentId);
  }

  Future<void> addStudents(
      {required String name,
      required String email,
      required String phone,
        required String gender,
      required BuildContext context}) async {
    final uuid = const Uuid().v4();
    try {
      await db
          .collection('students')
          .doc(uuid)
          .set({'id': uuid, 'name': name, 'email': email, 'phone': phone, 'gender': gender});
      await Fluttertoast.showToast(
        msg: "Student details added",
        toastLength: Toast.LENGTH_LONG,
      );
      await getStudents();
      notifyListeners();
    } catch (error) {
      GlobalMethods.errorDialog(msg: error.toString(), context: context);
    }
  }

// Future<void> updateStudent(String id, String name, String email, String phone) async {
//   try {
//     await db.collection('students').doc(id).update({
//       'name': name,
//       'email': email,
//       'phone': phone,
//     });
//     await getStudents();
//     notifyListeners();
//   } catch (e) {
//     print("Error updating student: $e");
//   }
// }
}
