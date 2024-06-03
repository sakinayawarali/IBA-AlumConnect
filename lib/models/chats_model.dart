import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final List<String> members;
  final String lastMessage;
  final Timestamp lastMessageTimestamp;

  Chat({
    required this.chatId,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTimestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      members: List<String>.from(json['members']),
      lastMessage: json['lastMessage'],
      lastMessageTimestamp: json['lastMessageTimestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }
}
