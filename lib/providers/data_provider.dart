import 'package:authentication_app/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<DataModel> _dataList = [];
  DataModel? _selectedItem;

  List<DataModel> get dataList => _dataList;

  DataModel? get selectedItem => _selectedItem;

  void fetchData() {
    db.collection('data').snapshots().listen((snapshot) {
      _dataList = snapshot.docs
          .map((doc) => DataModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addData(DataModel data) async {
    await db.collection('data').doc().set(data.toMap());
    fetchData();
  }

  Stream<List<DataModel>> getData() {
    return db.collection('data').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DataModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  void setSelectedItem(DataModel item) {
    _selectedItem = item;
    notifyListeners();
  }

  void updateData(
      String id, String newTitle, String newDescription, String newCategory) {
    int index = _dataList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _dataList[index] = DataModel(
        id: id,
        title: newTitle,
        description: newDescription,
        category: newCategory,
        date: DateTime.now(),
      );
      _selectedItem = _dataList[index];
      notifyListeners();
    }
  }

  Future<void> deleteData(String id) async {
    await db.collection('data').doc(id).delete();
    fetchData();
  }
}
