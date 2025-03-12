import 'package:flutter/material.dart';
import '../models/data_model.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final DataModel data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${data.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Description: ${data.description}',
                style: const TextStyle(fontSize: 16)),
            Text('Category: ${data.category}',
                style: const TextStyle(fontSize: 16)),
            Text('Date: ${DateFormat.yMMMd().format(data.date)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
