import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/job_model.dart'; 

class JobCRUD {
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('jobs');

  // Create a new job record
  Future<void> createJob(Job job) async {
    try {
      DocumentReference docRef = await jobCollection.add(job.toJson());
      String jobId = docRef.id;
      print('Job record created successfully with ID: $jobId');
    } catch (e) {
      print('Error creating job record: $e');
    }
  }

  // Read a specific job record by ID
  Future<Job?> readJobById(String jobId) async {
    try {
      DocumentSnapshot doc = await jobCollection.doc(jobId).get();
      if (doc.exists) {
        return Job.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Job record with ID $jobId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading job record: $e');
      return null;
    }
  }

  // Read all job records
  Future<List<Job>> readAllJobs() async {
    try {
      QuerySnapshot querySnapshot = await jobCollection.get();
      return querySnapshot.docs
          .map((doc) => Job.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error reading all job records: $e');
      return [];
    }
  }

  // Update an existing job record
  Future<void> updateJob(String jobId, Job updatedJob) async {
    try {
      await jobCollection.doc(jobId).update(updatedJob.toJson());
      print('Job record updated successfully!');
    } catch (e) {
      print('Error updating job record: $e');
    }
  }

  // Delete a job record
  Future<void> deleteJob(String jobId) async {
    try {
      await jobCollection.doc(jobId).delete();
      print('Job record deleted successfully!');
    } catch (e) {
      print('Error deleting job record: $e');
    }
  }
}
