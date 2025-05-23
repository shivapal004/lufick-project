import 'package:authentication_app/firebase_options.dart';
import 'package:authentication_app/providers/course_provider.dart';
import 'package:authentication_app/providers/data_provider.dart';
import 'package:authentication_app/providers/enrollment_provider.dart';
import 'package:authentication_app/providers/student_provider.dart';
import 'package:authentication_app/providers/user_provider.dart';
import 'package:authentication_app/screens/auth/login_screen.dart';
import 'package:authentication_app/screens/home_screen.dart';
import 'package:authentication_app/screens/task_two/details/students/student_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => EnrollmentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.orange,
              titleTextStyle: TextStyle(fontSize: 22, color: Colors.black)),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return snapshot.hasData ? const HomeScreen() : const LoginScreen();
          },
        ),
        routes: {
          StudentDetails.routeName: (ctx) => const StudentDetails(),
        },
      ),
    );
  }
}
