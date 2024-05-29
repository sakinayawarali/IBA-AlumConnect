import 'package:flutter/material.dart';

class SearchDirectoryScreen extends StatefulWidget {
  @override
  _SearchDirectoryScreenState createState() => _SearchDirectoryScreenState();
}

class _SearchDirectoryScreenState extends State<SearchDirectoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Directory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField(
              value: _selectedFilter,
              items: ['All', 'Alumni', 'Students']
                  .map((filter) => DropdownMenuItem(
                        child: Text(filter),
                        value: filter,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value.toString();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.program),
                  // Add more user details as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Dummy user data (replace with actual data)
  List<User> users = [
    User(name: 'John Doe', program: 'Computer Science', type: 'Alumni'),
    User(name: 'Alice Smith', program: 'Engineering', type: 'Student'),
    // Add more user objects as needed
  ];

  // Function to filter users based on search query and selected filter
  List<User> get filteredUsers {
    if (_searchQuery.isEmpty && _selectedFilter == 'All') {
      return users;
    } else if (_selectedFilter == 'All') {
      return users
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      return users
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
              user.type == _selectedFilter)
          .toList();
    }
  }
}

// Model class for User
class User {
  final String name;
  final String program;
  final String type;

  User({required this.name, required this.program, required this.type});
}
