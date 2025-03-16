import 'package:authentication_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../providers/user_provider.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DataProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.dataList.isEmpty) {
            return const Center(child: Text("No items available"));
          }

          return ListView.builder(
            itemCount: dataProvider.dataList.length,
            itemBuilder: (context, index) {
              final data = dataProvider.dataList[index];
              return ListTile(
                title: Text(data.title),
                subtitle: Text("Category: ${data.category}"),
                trailing: IconButton(onPressed: (){
                  _deleteItem(context, data.id);
                }, icon: const Icon(Icons.delete)),
                onTap: () {
                  dataProvider.setSelectedItem(data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailScreen()),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FormScreen()));
          },
          child: const Icon(Icons.add)),
    );
  }

  void _deleteItem(BuildContext context, String id) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.deleteData(id);
    // Navigator.pop(context);
  }
}
