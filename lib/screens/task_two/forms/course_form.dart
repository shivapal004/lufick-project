import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../../../providers/course_provider.dart';
import '../../../services/global_methods.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController instructorController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? category;

  List<String> categories = [
    "Science",
    "Math",
    "Art",
    "Programming",
    "Design",
    "Marketing",
    "Business"
  ];

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(labelText: "Course Title")),
                DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: category,
                    items: categories.map((String category) {
                      return DropdownMenuItem(
                          value: category, child: Text(category));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        category = val;
                      });
                    }),
                TextField(
                    controller: instructorController,
                    decoration: const InputDecoration(labelText: "Instructor")),
                const SizedBox(height: 20),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateLabelText: "Start Date",
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onChanged: (val) {
                    setState(() {
                      startDate = DateTime.parse(val);
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Select a start date';
                    }
                    return null;
                  },
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateLabelText: "End Date",
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onChanged: (val) {
                    setState(() {
                      endDate = DateTime.parse(val);
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Select a end date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5,),
                ElevatedButton(
                    onPressed: () async{
                      final isValid = _formKey.currentState!.validate();
                      FocusScope.of(context).unfocus();
                      if(isValid){
                        try{
                          await courseProvider.addCourses(
                            title: titleController.text,
                            category: category.toString(),
                            instructor: instructorController.text,
                            startDate: startDate,
                            endDate: endDate,
                            context: context
                          );
                        } catch(error){
                          GlobalMethods.errorDialog(msg: error.toString(), context: context);
                        }
                      }

                    },
                    child: const Text("Add Course"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
