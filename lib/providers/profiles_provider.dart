import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage user profiles
final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, List<Map<String, dynamic>>>((ref) {
  return ProfilesNotifier();
});

// Provider to manage connection status between two users
final connectionStatusProvider =
    FutureProvider.family<bool, String>((ref, userId) async {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return false;

  final user1Id = currentUser.uid;
  final user2Id = userId;

  final querySnapshot = await FirebaseFirestore.instance
      .collection('connections')
      .where('user1ERP', isEqualTo: user1Id)
      .where('user2ERP', isEqualTo: user2Id)
      .get();

  if (querySnapshot.docs.isEmpty) {
    final reverseQuerySnapshot = await FirebaseFirestore.instance
        .collection('connections')
        .where('user1ERP', isEqualTo: user2Id)
        .where('user2ERP', isEqualTo: user1Id)
        .get();
    return reverseQuerySnapshot.docs.isNotEmpty;
  }
  return querySnapshot.docs.isNotEmpty;
});

class ProfilesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ProfilesNotifier() : super([]);

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchAllUsers() async {
    QuerySnapshot userQuerySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    QuerySnapshot studentQuerySnapshot =
        await FirebaseFirestore.instance.collection('student').get();
    QuerySnapshot alumniQuerySnapshot =
        await FirebaseFirestore.instance.collection('alumni').get();

    state = [
      ...userQuerySnapshot.docs
          .where((doc) => doc.id != currentUser?.uid)
          .map((doc) => doc.data() as Map<String, dynamic>),
      ...studentQuerySnapshot.docs
          .where((doc) => doc['id'] != currentUser?.uid)
          .map((doc) => doc.data() as Map<String, dynamic>),
      ...alumniQuerySnapshot.docs
          .where((doc) => doc['id'] != currentUser?.uid)
          .map((doc) => doc.data() as Map<String, dynamic>),
    ];
  }

  void filterProfiles(String filter) async {
    if (filter == 'all') {
      fetchAllUsers();
    } else {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(filter).get();
      state = querySnapshot.docs
          .where((doc) => doc['id'] != currentUser?.uid)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
  }

  void searchProfiles(String query) {
    final normalizedQuery = _normalize(query);
    state = state.where((profile) {
      final fullName = '${profile['firstName']} ${profile['lastName']}';
      return _normalize(fullName).contains(normalizedQuery);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll(' ', '').toLowerCase();
  }
}
