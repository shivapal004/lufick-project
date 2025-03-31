import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/data_model.dart';
import '../../providers/data_provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final selectedItem = dataProvider.selectedItem;

    if (selectedItem == null) {
      return const Scaffold(
        body: Center(child: Text("No item selected")),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<DataProvider>(builder: (context, dataProvider, child) {
          final selectedItem = dataProvider.selectedItem;

          if (selectedItem == null) {
            return const Center(child: Text("No item selected"));
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Title: ${selectedItem.title}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Description: ${selectedItem.description}',
                    style: const TextStyle(fontSize: 16)),
                Text('Category: ${selectedItem.category}',
                    style: const TextStyle(fontSize: 16)),
                Text('Date: ${DateFormat.yMMMd().format(selectedItem.date)}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      _showUpdateDialog(context, dataProvider, selectedItem);
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showUpdateDialog(
      BuildContext context, DataProvider dataProvider, DataModel selectedItem) {
    TextEditingController titleController =
        TextEditingController(text: selectedItem.title);
    TextEditingController descriptionController =
        TextEditingController(text: selectedItem.description);
    TextEditingController categoryController =
        TextEditingController(text: selectedItem.category);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                dataProvider.updateData(selectedItem.id, {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'category': categoryController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
