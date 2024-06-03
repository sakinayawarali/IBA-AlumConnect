import 'package:devproj/models/chats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devproj/pages/shared_pages/chat_screen.dart';
import 'package:devproj/providers/chat_provider.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);

    if (chatNotifier.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Inbox'),
        ),
        body: Center(
          child: Text('You need to log in to see your inbox.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: chatState.isLoading
          ? Center(child: CircularProgressIndicator())
          : chatState.chats == null || chatState.chats!.isEmpty
              ? Center(child: Text('No chats available.'))
              : ListView.builder(
                  itemCount: chatState.chats!.length,
                  itemBuilder: (context, index) {
                    Chat chat = chatState.chats![index];
                    String chatId = chat.chatId;
                    String otherUserId = chat.members.firstWhere(
                        (member) => member != chatNotifier.currentUser!.uid,
                        orElse: () => 'Unknown User');
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: chatNotifier.fetchUserDetails(otherUserId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(title: Text('Loading...'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return ListTile(
                              title: Text('User details not found'));
                        }
                        var userProfile = snapshot.data!;
                        return ListTile(
                          title: Text(
                            '${userProfile['firstName'] ?? 'N/A'} ${userProfile['lastName'] ?? 'N/A'}',
                          ),
                          subtitle: Text(chat.lastMessage),
                          trailing: Text(
                              chat.lastMessageTimestamp.toDate().toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chatId,
                                  receiverId: otherUserId,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showConnectionsDialog(context, chatNotifier),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showConnectionsDialog(
      BuildContext context, ChatNotifier chatNotifier) async {
    List<Map<String, dynamic>> connections =
        await chatNotifier.fetchConnections();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Connection'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: connections.length,
              itemBuilder: (context, index) {
                var connection = connections[index];
                return ListTile(
                  title: Text(
                      '${connection['firstName']} ${connection['lastName']}'),
                  onTap: () {
                    Navigator.pop(context);
                    String chatId = chatNotifier.generateChatId(
                        chatNotifier.currentUser!.uid, connection['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chatId,
                          receiverId: connection['id'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
