import 'package:devproj/repositories/job_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/job_model.dart';
import 'package:url_launcher/url_launcher.dart';


class JobListingScreen extends StatefulWidget {
  @override
  _JobListingScreenState createState() => _JobListingScreenState();
}

class _JobListingScreenState extends State<JobListingScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    if (currentUser == null) return;
    List<Job> fetchedJobs = await JobCRUD().readAllJobs();
    setState(() {
      jobs =
          fetchedJobs.where((job) => job.postedBy != currentUser!.uid).toList();
    });
  }

  Widget _buildJobTile(Job job) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(job.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${job.company}'),
            Text('Location: ${job.location}'),
            Text('Type: ${job.type}'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Open job form link
                launch(job.formLink);
              },
              child: Text('Apply Now'),
            ),
          ],
        ),
        onTap: () {
          // Navigate to job detail page if needed
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: jobs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobTile(jobs[index]);
                },
              ),
      ),
    );
  }
}
