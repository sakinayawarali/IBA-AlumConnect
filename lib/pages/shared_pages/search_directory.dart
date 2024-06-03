import 'package:devproj/models/connections_model.dart';
import 'package:devproj/pages/shared_pages/chat_screen.dart';
import 'package:devproj/pages/shared_pages/public_profile.dart';
import 'package:devproj/providers/profiles_provider.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/theme/app_fonts.dart';
import 'package:devproj/repositories/connections_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchDirectoryPage extends ConsumerStatefulWidget {
  const SearchDirectoryPage({Key? key}) : super(key: key);

  @override
  _SearchDirectoryPageState createState() => _SearchDirectoryPageState();
}

class _SearchDirectoryPageState extends ConsumerState<SearchDirectoryPage> {
  String userTypeFilter = 'all'; // default filter
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    ref.read(profilesProvider.notifier).fetchAllUsers();
  }

  Future<void> _handleConnect(BuildContext context, String userId) async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final user1Id = currentUser!.uid;
    final user2Id = userId;

    final connection = Connection(
      status: 'pending',
      user1ERP: user1Id,
      user2ERP: user2Id,
    );

    final connectionCRUD = ConnectionCRUD();
    await connectionCRUD.createConnection(connection);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connection request sent.')),
    );
  }

  String _generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }

  Widget _buildProfileTile(Map<String, dynamic> profileData) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          '${profileData['firstName']} ${profileData['lastName']}',
          style: AppStyles.mediumHeading,
        ),
        subtitle: Text(profileData['email']),
        trailing: Consumer(
          builder: (context, watch, child) {
            final connectionStatus =
                ref.watch(connectionStatusProvider(profileData['id']));
            return connectionStatus.when(
              data: (isConnected) {
                if (isConnected) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: null, // Disable button
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            textStyle: TextStyle(color: Colors.black),
                          ),
                          child: Text('Following'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            String chatId = _generateChatId(
                                currentUser!.uid, profileData['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chatId,
                                  receiverId: profileData['id'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red, // Background color
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          child: Text('Message'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () =>
                              _handleConnect(context, profileData['id']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            textStyle: TextStyle(color: Colors.black),
                          ),
                          child: Text('Connect'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            String chatId = _generateChatId(
                                currentUser!.uid, profileData['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chatId,
                                  receiverId: profileData['id'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red, // Background color
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          child: Text('Message'),
                        ),
                      ),
                    ],
                  );
                }
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublicProfilePage(userProfile: profileData),
            ),
          );
        },
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200, // Make the filter box larger
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filter Options', style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  value: userTypeFilter,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      ref
                          .read(profilesProvider.notifier)
                          .filterProfiles(newValue);
                    }
                    Navigator.pop(context); // Close the modal
                  },
                  items: <String>['all', 'student', 'alumni']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ), // Use your preferred text style
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            _showFilterOptions(context);
          },
        ),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (query) {
        ref.read(profilesProvider.notifier).searchProfiles(query);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildSearchField(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: searchResults.isEmpty
            ? Center(child: Text('No profiles found'))
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return _buildProfileTile(searchResults[index]);
                },
              ),
      ),
    );
  }
}
