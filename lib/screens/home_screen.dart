import 'package:authentication_app/screens/BMI%20Calculator/bmi_home_page.dart';
import 'package:authentication_app/screens/profile_screen.dart';
import 'package:authentication_app/screens/task_one/main_screen.dart';
import 'package:authentication_app/screens/task_two/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../providers/data_provider.dart';
import '../providers/enrollment_provider.dart';
import '../providers/student_provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () async {
      final studentProvider =
          Provider.of<StudentProvider>(context, listen: false);
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      final enrollmentProvider =
          Provider.of<EnrollmentProvider>(context, listen: false);
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await studentProvider.getStudents();
      await courseProvider.getCourses();
      await enrollmentProvider.getEnrollments();
      await dataProvider.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MainScreen()));
                    },
                    child: const Text(
                      "Go to task 1 main screen",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DashboardScreen()));
                  },
                  child: const Text(
                    "Go to task 2 dashboard screen",
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BmiHomePage()));
                  },
                  child: const Text(
                    "BMI Calculator",
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
