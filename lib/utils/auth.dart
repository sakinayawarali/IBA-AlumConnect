import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/users_models/alumni_model.dart' as alumni_model;
import 'package:devproj/models/users_models/student_model.dart'
    as student_model;
import 'package:devproj/pages/shared_pages/welcome_screen.dart';
import 'package:devproj/repositories/alumni_repository.dart'
    as alumni_repository;
import 'package:devproj/repositories/student_repository.dart'
    as student_repository;
import 'package:devproj/repositories/notifications_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  

  static Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  static Future<void> handleSignUp(String userType, String? email,
      String? password, VoidCallback onSuccess) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );

      User? user = userCredential.user;
      if (user != null) {
        await _createUserRecord(user, userType);
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> signInWithGoogle(
      BuildContext context, String userType) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn
          .signOut(); // Ensure previous sign-in sessions are cleared
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in process
        print('Google sign-in was cancelled by the user.');
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      User? currentUser = userCredential.user;
      if (currentUser != null) {
        await _checkAndCreateUser(currentUser, userType);
        
      } else {
        print('User is not signed in.');
      }
    } catch (e) {
      print('Exception during Google sign-in: $e');
    }
  }

  static Future<void> _createUserRecord(User user, String userType) async {
    String uid = user.uid;
    String email = user.email ?? '';

    // Add user to 'users' collection
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'id': uid,
      'email': email,
      'userType': userType,
    });

    if (userType == 'alumni') {
      alumni_model.Alumni alumni = alumni_model.Alumni(
        id: uid,
        email: email,
      );
      await alumni_repository.AlumniCRUD().createAlumni(alumni);
    } else if (userType == 'student') {
      student_model.Student student = student_model.Student(
        id: uid,
        email: email,
      );
      await student_repository.StudentCRUD().createStudent(student);
    }
  }

  static Future<void> _checkAndCreateUser(User user, String userType) async {
    bool userExists = await (userType == 'alumni'
        ? alumni_repository.AlumniCRUD().checkUserExists(user.uid)
        : student_repository.StudentCRUD().checkUserExists(user.uid));

    if (!userExists) {
      await _createUserRecord(user, userType);
    }
    printCurrentUser();
  }

  static Future<void> signInWithEmailPassword(
      String? email, String? password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );

      if (userCredential.user != null) {
        User user = userCredential.user!;
        await _printUserType(user);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent.');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  static Future<void> signOutCurrentUser(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      print('User signed out successfully. ${_firebaseAuth.currentUser}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } catch (e) {
      print('Error signing out user: $e');
    }
  }

  static Future<void> _printUserType(User user) async {
    String uid = user.uid;
    String userEmail = user.email ?? '';

    bool isStudent =
        await student_repository.StudentCRUD().checkUserExists(uid);
    bool isAlumni = await alumni_repository.AlumniCRUD().checkUserExists(uid);

    if (isStudent) {
      print('Signed-in user is a student: $userEmail');
    } else if (isAlumni) {
      print('Signed-in user is an alumni: $userEmail');
    } else {
      print('User not found in student or alumni records: $userEmail');
    }
  }

  static void printCurrentUser() {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      print('Signed-in user: ${user.displayName} (${user.email})');
    } else {
      print('No user signed in.');
    }
  }
}

Future<String> getUserType(String userId) async {
  final studentSnapshot =
      await FirebaseFirestore.instance.collection('students').doc(userId).get();

  if (studentSnapshot.exists) {
    return 'student';
  }

  final alumniSnapshot =
      await FirebaseFirestore.instance.collection('alumni').doc(userId).get();

  if (alumniSnapshot.exists) {
    return 'alumni';
  }

  return 'unknown';
}

Future<dynamic> getUserDetails(String userId) async {
  String userType = await getUserType(userId);

  if (userType == 'student') {
    return await student_repository.StudentCRUD().readStudentById(userId);
  } else if (userType == 'alumni') {
    return await alumni_repository.AlumniCRUD().readAlumniById(userId);
  } else {
    return null;
  }
}

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void monitorMessages() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _firestore
          .collection('chats')
          .where('members', arrayContains: currentUser.uid)
          .snapshots()
          .listen((snapshot) {
        for (var docChange in snapshot.docChanges) {
          if (docChange.type == DocumentChangeType.added) {
            var data = docChange.doc.data() as Map<String, dynamic>;
            if (data['lastMessageSenderId'] != currentUser.uid) {
              NotificationService().showNotification(
                title: "New Message",
                body: data['lastMessage'] ?? 'You have a new message',
              );
            }
          }
        }
      });

      _firestore
          .collection('connections')
          .where('user2ERP', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        for (var docChange in snapshot.docChanges) {
          if (docChange.type == DocumentChangeType.added) {
            NotificationService().showNotification(
              title: "New Connection Request",
              body: "You have a new connection request",
            );
          }
        }
      });
    }
  }
}
