import 'package:devproj/pages/shared_pages/messaging.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: ListView.builder(
        itemCount: 10, // Example: 10 conversations
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('User $index'),
            subtitle: Text('Last message...'),
            onTap: () {
              // Navigate to the messaging screen for this user
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagingScreen(user: 'User $index'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
