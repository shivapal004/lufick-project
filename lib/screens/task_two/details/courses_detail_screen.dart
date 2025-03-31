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
  Set<String> selectedFilters = {};

  final List<String> filterOptions = ['Science', 'Math', 'Programming'];

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

        if (courseProvider.courses.isEmpty) {
          return const Center(
            child: Text("No course available"),
          );
        }

        final filteredCourses = courseProvider.courses.where((course) {
          final matchesCourse =
              course.title.toLowerCase().contains(searchQuery.toLowerCase());

          if (selectedFilters.isEmpty) return matchesCourse;

          bool matchesFilter = selectedFilters.any((filter) {
            if (filter == 'Science' && course.category.contains('Science')) {
              return true;
            }
            if (filter == 'Math' && course.category.contains('Math')) {
              return true;
            }
            if (filter == 'Programming' &&
                course.category.contains('Programming')) {
              return true;
            }
            return false;
          });
          return matchesCourse && matchesFilter;
        }).toList();

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
              SizedBox(
                height: 40,
                child: ListView.builder(
                    itemCount: filterOptions.length + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: const Row(
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text("Filters")
                              ],
                            ),
                            selected: false,
                            backgroundColor: Colors.blueGrey,
                            labelStyle: const TextStyle(color: Colors.white),
                            onSelected: (_) {},
                          ),
                        );
                      } else {
                        final filter = filterOptions[index - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilters.contains(filter),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.grey[300],
                            labelStyle: TextStyle(
                                color: selectedFilters.contains(filter)
                                    ? Colors.white
                                    : Colors.black),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedFilters.add(filter);
                                } else {
                                  selectedFilters.remove(filter);
                                }
                              });
                            },
                          ),
                        );
                      }
                    }),
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
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: filteredCourses.isEmpty
                    ? const Center(
                        child: Text("No course found"),
                      )
                    : ListView.builder(
                        itemCount: filteredCourses.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return Card(
                            elevation: 2,
                            color: Colors.orange.withOpacity(0.5),
                            child: ListTile(
                              title: Text(course.title),
                              subtitle: Text(
                                  "Enrolled Students: ${course.studentCount}"),
                            ),
                          );
                        }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
