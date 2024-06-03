import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/users_models/student_model.dart'
    as student_model;

class StudentCRUD {
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('student');
  // Create a new student record
  Future<void> createStudent(student_model.Student student) async {
    try {
      // Check if a student with the given email already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('email', isEqualTo: student.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no existing student is found, create a new one
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('student')
            .add(student.toJson());
        String studentId = docRef.id;
        print('Student record created successfully with ID: $studentId');
      } else {
        print('Student with email ${student.email} already exists.');
      }
    } catch (e) {
      print('Error creating student record: $e');
    }
  }

   // Read a specific student record by ID
  Future<student_model.Student?> readStudentById(String studentId) async {
    try {
      DocumentSnapshot doc = await studentCollection.doc(studentId).get();
      if (doc.exists) {
        return student_model.Student.fromDocument(doc);
      } else {
        print('Student record with ID $studentId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading student record: $e');
      return null;
    }
  }

  // Update an existing student record
  Future<void> updateStudent(
      String studentId, student_model.Student updatedStudent) async {
    try {
      await studentCollection.doc(studentId).update(updatedStudent.toJson());
      print('Student record updated successfully!');
    } catch (e) {
      print('Error updating student record: $e');
    }
  }

  // Delete a student record
  Future<void> deleteStudent(String studentId) async {
    try {
      await studentCollection.doc(studentId).delete();
      print('Student record deleted successfully!');
    } catch (e) {
      print('Error deleting student record: $e');
    }
  }

  // Check if a user with the given ID exists in the student collection
  Future<bool> checkUserExists(String userId) async {
    try {
      DocumentSnapshot doc =
          await studentCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking student user existence: $e');
      return false;
    }
  }
}

