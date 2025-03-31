import 'package:authentication_app/screens/task_two/details/courses_detail_screen.dart';
import 'package:authentication_app/screens/task_two/details/enrollments_detail_screen.dart';
import 'package:authentication_app/screens/task_two/details/students/students_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/enrollment_provider.dart';
import 'forms/all_forms_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                return _listTiles(
                    title: 'Students detail',
                    subtitle:
                        'Total students: ${studentProvider.students.length}',
                    icon: Icons.person,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const StudentsScreen()));
                    });
              },
            ),
            Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                return _listTiles(
                    title: 'Courses detail',
                    subtitle: 'Total courses: ${courseProvider.courses.length}',
                    icon: Icons.book,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CoursesDetailScreen()));
                    });
              },
            ),
            Consumer<EnrollmentProvider>(
              builder: (context, enrollmentProvider, child) {
                return _listTiles(
                    title: 'Enrollments detail',
                    subtitle:
                        'Total enrollments: ${enrollmentProvider.enrollments.length}',
                    icon: Icons.fact_check_rounded,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EnrollmentsDetailScreen()));
                    });
              },
            ),


          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AllFormsScreen()));
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _listTiles(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Function function}) {
    return Card(
      elevation: 1,
      color: Colors.orange.withOpacity(0.5),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
        onTap: () {
          function();
        },
      ),
    );
  }
}
