import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> streamUsers() {
    return usersCollection.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> createUsers(String name, String description) async {
    await usersCollection.add({
      'name': name,
      'description': description,
      'createdAt': Timestamp.now(),
    });
  }
}
