import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/users_models/alumni_model.dart' as alumni_model;
import 'package:devproj/models/users_models/alumni_model.dart';

class AlumniCRUD {
  final CollectionReference alumniCollection =
      FirebaseFirestore.instance.collection('alumni');

  // Create a new alumni record
  Future<void> createAlumni(Alumni alumni) async {
    try {
      // Check if an alumni with the given email already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('alumni')
          .where('email', isEqualTo: alumni.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no existing alumni is found, create a new one
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('alumni')
            .add(alumni.toJson());
        String alumniId = docRef.id;
        print('Alumni record created successfully with ID: $alumniId');
      } else {
        print('Alumni with email ${alumni.email} already exists.');
      }
    } catch (e) {
      print('Error creating alumni record: $e');
    }
  }

  // Read a specific alumni record by ID
  Future<alumni_model.Alumni?> readAlumniById(String alumniId) async {
    try {
      DocumentSnapshot doc = await alumniCollection.doc(alumniId).get();
      if (doc.exists) {
        return alumni_model.Alumni.fromDocument(doc);
      } else {
        print('Alumni record with ID $alumniId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading alumni record: $e');
      return null;
    }
  }
  
  // Update an existing alumni record
  Future<void> updateAlumni(String alumniId, Alumni updatedAlumni) async {
    try {
      await alumniCollection.doc(alumniId).update(updatedAlumni.toJson());
      print('Alumni record updated successfully!');
    } catch (e) {
      print('Error updating alumni record: $e');
    }
  }

  // Delete an alumni record
  Future<void> deleteAlumni(String alumniId) async {
    try {
      await alumniCollection.doc(alumniId).delete();
      print('Alumni record deleted successfully!');
    } catch (e) {
      print('Error deleting alumni record: $e');
    }
  }

  // Check if an alumni with the given ID exists in the alumni collection
  Future<bool> checkAlumniExists(String alumniId) async {
    try {
      DocumentSnapshot doc = await alumniCollection.doc(alumniId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking alumni existence: $e');
      return false;
    }
  }

  
  // Check if a user with the given ID exists in the student collection
  Future<bool> checkUserExists(String userId) async {
    try {
      DocumentSnapshot doc = await alumniCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking student user existence: $e');
      return false;
    }
  }
}
