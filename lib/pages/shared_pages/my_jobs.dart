import 'package:devproj/repositories/job_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/job_model.dart';

class MyJobsScreen extends StatefulWidget {
  @override
  _MyJobsScreenState createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final JobCRUD jobService = JobCRUD();
  User? user = FirebaseAuth.instance.currentUser;
  List<Job> myJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    if (user != null) {
      List<Job> jobs = await jobService.readAllJobs();
      setState(() {
        myJobs = jobs.where((job) => job.postedBy == user!.uid).toList();
      });
    }
  }

  void _editJob(Job job) async {
    TextEditingController titleController =
        TextEditingController(text: job.title);
    TextEditingController descriptionController =
        TextEditingController(text: job.description);
    TextEditingController companyController =
        TextEditingController(text: job.company);
    TextEditingController locationController =
        TextEditingController(text: job.location);
    TextEditingController typeController =
        TextEditingController(text: job.type);
    TextEditingController formLinkController =
        TextEditingController(text: job.formLink);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Job'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: companyController,
                decoration: InputDecoration(labelText: 'Company'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: formLinkController,
                decoration: InputDecoration(labelText: 'Form Link'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Job updatedJob = Job(
                company: companyController.text,
                description: descriptionController.text,
                formLink: formLinkController.text,
                location: locationController.text,
                postedBy: job.postedBy,
                title: titleController.text,
                type: typeController.text,
              );
              await jobService.updateJob(job.postedBy, updatedJob);
              Navigator.of(context).pop();
              _loadJobs();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteJob(String id) async {
    await jobService.deleteJob(id);
    _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Jobs'),
      ),
      body: myJobs.isEmpty
          ? Center(child: Text('No jobs found'))
          : ListView.builder(
              itemCount: myJobs.length,
              itemBuilder: (context, index) {
                Job job = myJobs[index];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editJob(job),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteJob(job.postedBy),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
