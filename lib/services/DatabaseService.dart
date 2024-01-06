import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/User.dart';

class DatabaseService {
  final String USER_COLLECTION_NAME = "users";
  final String TASK_COLLECTION_NAME = "task";
  final String TODO_COLLECTION_NAME = "todo";

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future<String> getUserId(String email) async {
    print("email for get id user : ${email}");
    final usersCollection =
        FirebaseFirestore.instance.collection(USER_COLLECTION_NAME);
    final querySnapshot = await usersCollection
        .where("email", isEqualTo: email)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        )
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      final userId = document.id; // Get the document ID

      return userId;
    } else {
      return '';
    }
  }
}
