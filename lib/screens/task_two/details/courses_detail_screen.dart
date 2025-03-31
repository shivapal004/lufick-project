import 'package:authentication_app/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/search_field_widget.dart';

class CoursesDetailScreen extends StatefulWidget {
  const CoursesDetailScreen({super.key});

  @override
  State<CoursesDetailScreen> createState() => _CoursesDetailScreenState();
}

class _CoursesDetailScreenState extends State<CoursesDetailScreen> {
  final TextEditingController courseSearchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<CourseProvider>(context, listen: false).getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses detail"),
      ),
      body: Consumer<CourseProvider>(builder: (context, courseProvider, child) {
        final popularCourses = courseProvider.getPopularCourses();

        final filteredCourses = courseProvider.courses.where((course) =>
            course.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchField(
                controller: courseSearchController,
                onSearch: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                hintText: 'Search by course',
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Total courses: ${filteredCourses.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Divider(
                height: 2,
                thickness: 2,
                indent: 80,
                endIndent: 80,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: ListView.builder(itemCount: filteredCourses.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return Card(
                          elevation: 1,
                          color: Colors.orange.withOpacity(0.5),
                          child: ListTile(
                            title: Text(course.title),
                            subtitle: Text(
                                "Enrolled Students: ${course.studentCount}"),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
