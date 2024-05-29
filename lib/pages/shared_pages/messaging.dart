import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  final String user;

  const MessagingScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example: 10 messages
              itemBuilder: (context, index) {
                // Example: Replace with actual message data
                return ListTile(
                  title: Text('Message $index'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Add logic to send the message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
