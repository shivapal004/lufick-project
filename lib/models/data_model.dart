import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  String id;
  String title;
  String description;
  DateTime date;
  String category;

  DataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });

  factory DataModel.fromMap(Map<String, dynamic> map, String id) {
    return DataModel(
        id: id,
        title: map['title'] ?? "",
        description: map['description'] ?? "",
        date: (map['date'] as Timestamp).toDate(),
        category: map['category'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'category': category
    };
  }
}
