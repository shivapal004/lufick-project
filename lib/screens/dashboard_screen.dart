import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/course_provider.dart';
import '../providers/enrollment_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).getStudents();
      Provider.of<CourseProvider>(context, listen: false).getCourses();
      Provider.of<EnrollmentProvider>(context, listen: false).getEnrollments();
    });
  }

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
                return Text(
                  'Total Students: ${studentProvider.students.length}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                return Text(
                  'Total Courses: ${courseProvider.courses.length}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            Consumer<EnrollmentProvider>(
              builder: (context, enrollmentProvider, child) {
                return Text(
                  'Total Enrollments: ${enrollmentProvider.enrollments.length}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 20),
            // const Text(
            //   'Most Popular Courses:',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // Expanded(
            //   child: Consumer<CourseProvider>(
            //     builder: (context, courseProvider, child) {
            //       final popularCourses = courseProvider.getPopularCourses();
            //       return ListView.builder(
            //         itemCount: popularCourses.length,
            //         itemBuilder: (context, index) {
            //           var course = popularCourses[index];
            //           return ListTile(
            //             title: Text(course.title),
            //             subtitle: Text('Enrolled: ${course.studentCount}'),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
