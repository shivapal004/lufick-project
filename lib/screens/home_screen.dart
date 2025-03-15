import 'package:authentication_app/screens/form_screen.dart';
import 'package:authentication_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../providers/user_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final user = userProvider.user;

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
      body: ListView.builder(
          itemCount: dataProvider.dataList.length,
          itemBuilder: (context, index) {
            final data = dataProvider.dataList[index];
            return ListTile(
              title: Text(data.title),
              subtitle: Text(data.category),
              // trailing: Text(DateFormat.yMMMd().format(data.date)),
              onTap: () {
                dataProvider.setSelectedItem(data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailScreen(),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => dataProvider.deleteData(data.id),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FormScreen()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
