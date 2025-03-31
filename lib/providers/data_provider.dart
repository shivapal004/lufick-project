import 'package:authentication_app/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  List<DataModel> _dataList = [];
  DataModel? _selectedItem;

  List<DataModel> get dataList => _dataList;

  DataModel? get selectedItem => _selectedItem;

  Future<void> fetchData() async{
    if (_user == null) return;
    db
        .collection('users')
        .doc(_user.uid)
        .collection('data')
        .snapshots()
        .listen((snapshot) {
      _dataList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return DataModel.fromMap(data);
      }).toList();

      notifyListeners();
    });
  }


  Future<void> addData(DataModel data) async {
    if (_user == null) return;
    await db
        .collection('users')
        .doc(_user.uid)
        .collection('data')
        .add(data.toMap());
    fetchData();
    notifyListeners();
  }

  void setSelectedItem(DataModel item) {
    _selectedItem = item;
    notifyListeners();
  }

  Future<void> updateData(String id, Map<String, dynamic> updatedData) async {
    if (_user == null) return;
    await db
        .collection('users')
        .doc(_user.uid)
        .collection('data')
        .doc(id)
        .update(updatedData);

    int index = _dataList.indexWhere((item) => item.id == id);
    if (index != -1) {
      dataList[index] = DataModel(
        id: id,
        title: updatedData['title'] ?? _dataList[index].title,
        description: updatedData['description'] ?? _dataList[index].description,
        category: updatedData['category'] ?? _dataList[index].category,
        date: DateTime.now(), // Update with new timestamp
      );
    }
    notifyListeners();
  }

  Future<void> deleteData(String id) async {
    if (_user == null) return;
    await db
        .collection('users')
        .doc(_user.uid)
        .collection('data')
        .doc(id)
        .delete();
    dataList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
