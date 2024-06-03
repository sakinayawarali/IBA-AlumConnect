import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/chats_model.dart';
import 'package:devproj/models/messages_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Start a new chat if it doesn't exist
  Future<void> startChat(String chatId, String user1Id, String user2Id) async {
    DocumentReference chatDocRef = _firestore.collection('chats').doc(chatId);
    DocumentSnapshot chatDoc = await chatDocRef.get();

    if (!chatDoc.exists) {
      Chat chat = Chat(
        chatId: chatId,
        members: [user1Id, user2Id],
        lastMessage: '',
        lastMessageTimestamp: Timestamp.now(),
      );
      await chatDocRef.set(chat.toJson());
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef = _firestore.collection('chats').doc(chatId);
    await chatDocRef.collection('messages').add(message.toJson());
    await chatDocRef.update({
      'lastMessage': message.message,
      'lastMessageTimestamp': message.timestamp,
    });
  }

  // Fetch messages
  Stream<List<Message>> fetchMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Fetch chat summaries for the current user
  Stream<List<Chat>> fetchChatSummaries(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
