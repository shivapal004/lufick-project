import 'package:authentication_app/screens/course_form.dart';
import 'package:authentication_app/screens/enrollment_form.dart';
import 'package:authentication_app/screens/student_form.dart';
import 'package:flutter/material.dart';

class AllFormsScreen extends StatelessWidget {
  const AllFormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _listTiles(
            title: 'Students',
            subtitle: 'Fill student details',
            icon: Icons.person,
            function: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentForm()));
            }
          ),
          _listTiles(
              title: 'Courses',
              subtitle: 'Fill course details',
              icon: Icons.book,
              function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseForm()));
              }
          ),
          _listTiles(
              title: 'Enrollments',
              subtitle: 'Fill enrollment details',
              icon: Icons.book,
              function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EnrollmentForm()));
              }
          ),
        ],
      ),
    );
  }

  Widget _listTiles(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Function function}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
      onTap: () {
        function();
      },
    );
  }
}
