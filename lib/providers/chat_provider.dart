import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/chats_model.dart';
import 'package:devproj/repositories/chat_functions.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatState {
  final List<Chat>? chats;
  final bool isLoading;
  final String? error;

  ChatState({
    this.chats,
    this.isLoading = false,
    this.error,
  });
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  final ChatService _chatService = ChatService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void fetchChats() async {
    if (currentUser == null) return;
    state = ChatState(isLoading: true);

    try {
      final chats =
          await _chatService.fetchChatSummaries(currentUser!.uid).first;
      state = ChatState(chats: chats);
    } catch (e) {
      state = ChatState(error: e.toString());
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchConnections() async {
    if (currentUser == null) return [];
    String currentUserId = currentUser!.uid;

    List<Map<String, dynamic>> connections = [];
    try {
      // Fetching connections where the current user is either user1ERP or user2ERP
      QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('status', isEqualTo: 'accepted')
          .where('user1ERP', isEqualTo: currentUserId)
          .get();

      for (var doc in connectionsSnapshot.docs) {
        String user2Id = doc['user2ERP'];
        var userDetails = await fetchUserDetails(user2Id);
        if (userDetails != null) {
          connections.add(userDetails);
        }
      }

      connectionsSnapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('status', isEqualTo: 'accepted')
          .where('user2ERP', isEqualTo: currentUserId)
          .get();

      for (var doc in connectionsSnapshot.docs) {
        String user1Id = doc['user1ERP'];
        var userDetails = await fetchUserDetails(user1Id);
        if (userDetails != null) {
          connections.add(userDetails);
        }
      }
    } catch (e) {
      print(e);
    }

    return connections;
  }

  String generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }
}
