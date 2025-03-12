import 'package:authentication_app/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addData(DataModel data) async {
    await _firebaseFirestore.collection('data').doc().set(data.toMap());
  }

  Stream<List<DataModel>> getData() {
    return _firebaseFirestore.collection('data').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DataModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
