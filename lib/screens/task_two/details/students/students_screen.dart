import 'package:authentication_app/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/search_field_widget.dart';
import 'student_details.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsDetailScreenState();
}

class _StudentsDetailScreenState extends State<StudentsScreen> {
  final TextEditingController studentSearchController = TextEditingController();
  String searchQuery = '';
  Set<String> selectedFilters = {};

  final List<String> filterOptions = [
    'Gmail Users',
    'Yahoo Users',
    'Male',
    'Female',
    'Phone +91',
    'Phone +44',
  ];

  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false).getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Screen'),
      ),
      body:
          Consumer<StudentProvider>(builder: (context, studentProvider, child) {
        if (studentProvider.students.isEmpty) {
          return const Center(
            child: Text("Student list is empty"),
          );
        }

        final filteredStudents = studentProvider.students.where((student) {
          final matchesName =
              student.name.toLowerCase().contains(searchQuery.toLowerCase());

          if (selectedFilters.isEmpty) return matchesName;

          bool matchesFilter = selectedFilters.any((filter) {
            if (filter == 'Gmail Users' &&
                student.email.endsWith('@gmail.com')) {
              return true;
            }
            if (filter == 'Yahoo Users' &&
                student.email.endsWith('@yahoo.com')) {
              return true;
            }
            if (filter == 'Male' && student.gender.contains('Male')) {
              return true;
            }
            if (filter == 'Female' && student.gender.contains('Female')) {
              return true;
            }
            if (filter == 'Phone +91' && student.phone.startsWith('+91')) {
              return true;
            }
            if (filter == 'Phone +44' && student.phone.startsWith('+44')) {
              return true;
            }
            return false;
          });

          return matchesName && matchesFilter;
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchField(
                controller: studentSearchController,
                onSearch: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                hintText: 'Search by name',
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterOptions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "Filter" label with icon
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: const Row(
                            children: [
                              Icon(Icons.filter_list,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text("Filters"),
                            ],
                          ),
                          selected: false,
                          backgroundColor: Colors.blueGrey,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (_) {},
                        ),
                      );
                    } else {
                      // Other filters
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
                                : Colors.black,
                          ),
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
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Total students: ${filteredStudents.length}',
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
                child: filteredStudents.isEmpty
                    ? const Center(child: Text("No student found"))
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return Card(
                            elevation: 2,
                            color: Colors.orange.withOpacity(0.5),
                            child: ListTile(
                              title: Text(student.name),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, StudentDetails.routeName,
                                    arguments: student.id);
                              },
                            ),
                          );
                        }),
              )
            ],
          ),
        );
      }),
    );
  }
}
