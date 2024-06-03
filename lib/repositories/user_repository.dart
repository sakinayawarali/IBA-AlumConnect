import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/users_models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add user to the main 'users' collection
  Future<void> addUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());

    // Create a document in the 'alumni' or 'student' collection based on userType
    if (user.userType == 'alumni') {
      await _db.collection('alumni').doc(user.id).set({
        'id': user.id,
        'email': user.email,
        // Add additional fields as needed
      });
    } else if (user.userType == 'student') {
      await _db.collection('student').doc(user.id).set({
        'id': user.id,
        'email': user.email,
        // Add additional fields as needed
      });
    }
  }
}
