import 'package:authentication_app/providers/enrollment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/search_field_widget.dart';

class EnrollmentsDetailScreen extends StatefulWidget {
  const EnrollmentsDetailScreen({super.key});

  @override
  State<EnrollmentsDetailScreen> createState() =>
      _EnrollmentsDetailScreenState();
}

class _EnrollmentsDetailScreenState extends State<EnrollmentsDetailScreen> {
  late Future<List<Map<String, dynamic>>> _courseData;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _courseData = Provider.of<EnrollmentProvider>(context, listen: false)
        .getCoursesWithEnrolledStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Enrollments detail"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchField(
                controller: searchController,
                onSearch: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                hintText: 'Search by Course, Instructor, or Student',
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _courseData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No courses found'));
                  }

                  final filteredCourses = snapshot.data!.where((courseData) {
                    var course = courseData['course'];
                    var students = courseData['students'];

                    bool matchesCourse = course['title']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery);
                    bool matchesInstructor = course['instructor']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery);
                    bool matchesStudent = students.any((student) =>
                        student['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery));

                    return matchesCourse || matchesInstructor || matchesStudent;
                  }).toList();

                  return filteredCourses.isEmpty
                      ? const Center(child: Text("No matching results"))
                      : ListView.builder(
                          itemCount: filteredCourses.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var course = filteredCourses[index]['course'];
                            var students = filteredCourses[index]['students'];

                            return Card(
                              elevation: 1,
                              color: Colors.orange.withOpacity(0.5),
                              margin: const EdgeInsets.all(10),
                              child: ExpansionTile(
                                title: Text(course['title']),
                                subtitle:
                                    Text('Instructor: ${course['instructor']}'),
                                children: students.isNotEmpty
                                    ? students
                                        .map<Widget>((student) => ListTile(
                                              tileColor: Colors.orange
                                                  .withOpacity(0.8),
                                              title: Text(student['name']),
                                              subtitle: Text(student['email']),
                                            ))
                                        .toList()
                                    : [
                                        const ListTile(
                                            title: Text('No students enrolled'))
                                      ],
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ));
  }
}
