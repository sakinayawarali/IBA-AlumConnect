import 'package:devproj/pages/shared_pages/public_profile.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ViewNetworkPage extends StatefulWidget {
  const ViewNetworkPage({Key? key}) : super(key: key);

  @override
  _ViewNetworkPageState createState() => _ViewNetworkPageState();
}

class _ViewNetworkPageState extends State<ViewNetworkPage>
    with SingleTickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> acceptedConnections = [];
  List<Map<String, dynamic>> connectionRequests = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchConnections();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchConnections() async {
    if (currentUser == null) return;

    String currentUserId = currentUser!.uid;

    // Fetch accepted connections where the current user is either user1ERP or user2ERP
    QuerySnapshot acceptedSnapshot1 = await FirebaseFirestore.instance
        .collection('connections')
        .where('user1ERP', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'accepted')
        .get();

    QuerySnapshot acceptedSnapshot2 = await FirebaseFirestore.instance
        .collection('connections')
        .where('user2ERP', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'accepted')
        .get();

    // Fetch connection requests where current user is the recipient (user2ERP)
    QuerySnapshot requestsSnapshot = await FirebaseFirestore.instance
        .collection('connections')
        .where('user2ERP', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    setState(() {
      acceptedConnections =
          [...acceptedSnapshot1.docs, ...acceptedSnapshot2.docs]
              .map((doc) => {
                    'docId': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
              .toList();

      connectionRequests = requestsSnapshot.docs
          .map((doc) => {
                'docId': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  Future<Map<String, dynamic>?> _fetchUserDetails(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> _updateConnectionStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(docId)
        .update({'status': status});
    _fetchConnections(); // Refresh the connection data after updating
  }

  Widget _buildAcceptedConnections() {
    return ListView.builder(
      itemCount: acceptedConnections.length,
      itemBuilder: (context, index) {
        String user1Id = acceptedConnections[index]['user1ERP'] ?? '';
        String user2Id = acceptedConnections[index]['user2ERP'] ?? '';
        String otherUserId = user1Id == currentUser!.uid
            ? user2Id
            : user1Id; // Get the other user
        return FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserDetails(otherUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return ListTile(title: Text('User details not found'));
            }
            var userProfile = snapshot.data!;
            return ListTile(
              title: Text(
                  '${userProfile['firstName'] ?? 'N/A'} ${userProfile['lastName'] ?? 'N/A'}'),
              subtitle: Text(userProfile['email'] ?? 'N/A'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PublicProfilePage(userProfile: userProfile),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildConnectionRequests() {
    return ListView.builder(
      itemCount: connectionRequests.length,
      itemBuilder: (context, index) {
        String user1Id = connectionRequests[index]['user1ERP'] ?? '';
        String connectionId = connectionRequests[index]['docId'] ?? '';
        return FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserDetails(user1Id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return ListTile(title: Text('User details not found'));
            }
            var userProfile = snapshot.data!;
            return ListTile(
              title: Text(
                  '${userProfile['firstName'] ?? 'N/A'} ${userProfile['lastName'] ?? 'N/A'}'),
              subtitle: Text(userProfile['email'] ?? 'N/A'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      _updateConnectionStatus(connectionId, 'accepted');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _updateConnectionStatus(connectionId, 'rejected');
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PublicProfilePage(userProfile: userProfile),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.red,
          tabs: [
            Tab(text: 'Connections'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAcceptedConnections(),
                _buildConnectionRequests(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
