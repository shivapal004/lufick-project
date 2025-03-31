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

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'category': category,
    };
  }
}
