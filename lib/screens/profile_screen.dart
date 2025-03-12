import 'dart:io';

import 'package:authentication_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    Future<void> _uploadImage(BuildContext context) async {
      ImagePicker imagePicker = ImagePicker();

      final XFile? pickedFile = await showModalBottomSheet(
          context: context, builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                final file = await imagePicker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final file = await imagePicker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, file);
              },
            ),
          ],
        );
      });

      if (pickedFile == null) return;

      File imageFile = File(pickedFile.path);

      try {
        String filePath = 'profile_images/${user?.uid}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        await storageRef.putFile(imageFile);
        String imageUrl = await storageRef.getDownloadURL();

        await user?.updatePhotoURL(imageUrl);
        await user?.reload();

        userProvider.setUser(FirebaseAuth.instance.currentUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user?.photoURL ?? ''),
                  radius: 80,
                ),
                Positioned(
                    right: 1,
                    bottom: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        onPressed: () {
                          _uploadImage(context);
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          // size: 30,
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Text(user?.displayName ?? 'No Name',
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(user?.email ?? 'No Email',
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
              const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
