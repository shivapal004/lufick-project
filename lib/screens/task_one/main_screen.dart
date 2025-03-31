import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              if (dataProvider.dataList.isEmpty) {
                return const Center(child: Text("No items available"));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataProvider.dataList.length,
                  itemBuilder: (context, index) {
                    final data = dataProvider.dataList[index];
                    return Card(
                      color: Colors.orange.withOpacity(0.6),
                      child: ListTile(
                        title: Text(data.title),
                        subtitle: Text("Category: ${data.category}"),
                        trailing: IconButton(
                            onPressed: () {
                              _deleteItem(context, data.id);
                            },
                            icon: const Icon(Icons.delete)),
                        onTap: () {
                          dataProvider.setSelectedItem(data);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DetailScreen()),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FormScreen()));
          },
          child: const Icon(Icons.add)),
    );
  }

  void _deleteItem(BuildContext context, String id) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.deleteData(id);
  }
}
