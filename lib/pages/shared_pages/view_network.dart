import 'package:flutter/material.dart';

class ViewNetworksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Networks'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        children: [
          // Connection Requests Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Requests',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                // List of connection requests (replace with actual data)
                ListTile(
                  title: Text('John Doe'),
                  subtitle: Text('Program: MBA'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          // Accept connection request
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Reject connection request
                        },
                      ),
                    ],
                  ),
                ),
                // Add more ListTile widgets for additional connection requests
              ],
            ),
          ),
          // Divider between connection requests and connections
          Divider(),
          // Connections Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connections',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                // List of connections (replace with actual data)
                ListTile(
                  title: Text('Jane Smith'),
                  subtitle: Text('Program: Computer Science'),
                ),
                // Add more ListTile widgets for additional connections
              ],
            ),
          ),
        ],
      ),
    );
  }
}
