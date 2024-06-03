import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devproj/models/connections_model.dart';
import 'package:devproj/repositories/connections_functions.dart';

class PublicProfilePage extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const PublicProfilePage({Key? key, required this.userProfile})
      : super(key: key);

  Future<bool> _checkConnectionExists(String user1Id, String user2Id) async {
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
  }

  Future<void> _handleConnect(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final user1Id = currentUser.uid;
    final user2Id = userProfile['id'];

    if (user1Id == null || user2Id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to retrieve user IDs.')),
      );
      return;
    }

    if (await _checkConnectionExists(user1Id, user2Id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are already connected.')),
      );
      return;
    }

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

  Future<String?> _getUserId(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['id'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final user1Id = currentUser?.uid;
    final user2Id = userProfile['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${userProfile['firstName']} ${userProfile['lastName']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Email',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['email']),
              ),
              ListTile(
                title: Text('Employment Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    Text(userProfile['employmentStatus'] ?? 'Not provided'),
              ),
              ListTile(
                title:
                    Text('ERP', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['erp'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Gender',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['gender'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Graduation Batch',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['gradBatch'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Interests',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['interests'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('LinkedIn Link',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['linkedinLink'] ?? 'Not provided'),
              ),
              ListTile(
                title:
                    Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['city'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Country',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['country'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Phone',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['phone'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Program',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['program'] ?? 'Not provided'),
              ),
              ListTile(
                title: Text('Skills',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userProfile['skills'] ?? 'Not provided'),
              ),
              if (userProfile['userType'] == 'alumni') ...[
                ListTile(
                  title: Text('Company',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      userProfile['jobHistory']?['company'] ?? 'Not provided'),
                ),
                ListTile(
                  title: Text('End Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      userProfile['jobHistory']?['endDate'] ?? 'Not provided'),
                ),
                ListTile(
                  title: Text('Position',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      userProfile['jobHistory']?['position'] ?? 'Not provided'),
                ),
                ListTile(
                  title: Text('Start Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(userProfile['jobHistory']?['startDate'] ??
                      'Not provided'),
                ),
              ] else if (userProfile['userType'] == 'student') ...[
                ListTile(
                  title: Text('Project Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      userProfile['project']?['details'] ?? 'Not provided'),
                ),
                ListTile(
                  title: Text('Project Title',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      Text(userProfile['project']?['title'] ?? 'Not provided'),
                ),
              ],
              SizedBox(height: 20),
              FutureBuilder<bool>(
                future: _checkConnectionExists(user1Id!, user2Id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == true) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: null, // Disable button
                          child: Text('Following'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle message action
                          },
                          child: Text('Message'),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _handleConnect(context),
                          child: Text('Connect'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle message action
                          },
                          child: Text('Message'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
