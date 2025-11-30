import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/controller/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController _userController = UserController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  void showFormModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tambah User Baru",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                    labelText: "Description", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        descController.text.isNotEmpty) {
                      _userController.createUsers(
                          nameController.text, descController.text);

                      nameController.clear();
                      descController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 44, 77)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modul 12 - Firebase PART 1"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: showFormModal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userController.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Error memproses data"));
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final user = data.docs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 147, 195, 234),
                    child: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(user['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user['description']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
