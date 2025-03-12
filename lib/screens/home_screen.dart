import 'package:authentication_app/models/data_model.dart';
import 'package:authentication_app/screens/form_screen.dart';
import 'package:authentication_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/firestore_services.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final FirestoreServices firestoreServices = FirestoreServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<DataModel>>(
          stream: firestoreServices.getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error occurred '));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<DataModel> dataList = snapshot.data!;
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return ListTile(
                    title: Text(data.title),
                    subtitle: Text(data.category),
                    trailing: Text(DateFormat.yMMMd().format(data.date)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(data: data),
                        ),
                      );
                    },
                    // trailing: Text(DateFormat.yMMMd().format(data.date)),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const FormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
