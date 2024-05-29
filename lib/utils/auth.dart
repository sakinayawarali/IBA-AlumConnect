import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Sign in with Google
Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    print('Exception: $e');
  }
}

// Sign out from Google
Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}

// Firestore CRUD operations
// Create a new document
Future<void> createDocument(
    String collection, Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance.collection(collection).add(data);
  } catch (e) {
    print('Error adding document: $e');
  }
}

// Read a document
Future<DocumentSnapshot> readDocument(String collection, String docId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .get();
    return documentSnapshot;
  } catch (e) {
    print('Error reading document: $e');
    rethrow;
  }
}

// Update a document
Future<void> updateDocument(
    String collection, String docId, Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update(data);
  } catch (e) {
    print('Error updating document: $e');
  }
}

// Delete a document
Future<void> deleteDocument(String collection, String docId) async {
  try {
    await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
  } catch (e) {
    print('Error deleting document: $e');
  }
}
