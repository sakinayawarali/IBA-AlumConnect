import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/connections_model.dart'; // Adjust the import according to your project structure

class ConnectionCRUD {
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection('connections');

  // Create a new connection record
  Future<void> createConnection(Connection connection) async {
    try {
      DocumentReference docRef =
          await connectionCollection.add(connection.toJson());
      String connectionId = docRef.id;
      print('Connection record created successfully with ID: $connectionId');
    } catch (e) {
      print('Error creating connection record: $e');
    }
  }

  // Read a specific connection record by ID
  Future<Connection?> readConnectionById(String connectionId) async {
    try {
      DocumentSnapshot doc = await connectionCollection.doc(connectionId).get();
      if (doc.exists) {
        return Connection.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Connection record with ID $connectionId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading connection record: $e');
      return null;
    }
  }

  // Read all connection records
  Future<List<Connection>> readAllConnections() async {
    try {
      QuerySnapshot querySnapshot = await connectionCollection.get();
      return querySnapshot.docs
          .map((doc) => Connection.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error reading all connection records: $e');
      return [];
    }
  }

  // Update an existing connection record
  Future<void> updateConnection(
      String connectionId, Connection updatedConnection) async {
    try {
      await connectionCollection
          .doc(connectionId)
          .update(updatedConnection.toJson());
      print('Connection record updated successfully!');
    } catch (e) {
      print('Error updating connection record: $e');
    }
  }

  // Delete a connection record
  Future<void> deleteConnection(String connectionId) async {
    try {
      await connectionCollection.doc(connectionId).delete();
      print('Connection record deleted successfully!');
    } catch (e) {
      print('Error deleting connection record: $e');
    }
  }
}
