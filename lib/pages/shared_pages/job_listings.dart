import 'package:flutter/material.dart';

class JobListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
      ),
      body: ListView.builder(
        itemCount: 10, // Example: 10 job listings
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text('Job Title $index'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company Name $index'),
                    Text('Location $index'),
                    Text('Salary Range $index'),
                    // Add more details here as needed
                  ],
                ),
                onTap: () {
                  // Add logic to navigate to job details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsScreen(jobId: index),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class JobDetailsScreen extends StatelessWidget {
  final int jobId;

  const JobDetailsScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Job Title: Job Title $jobId'),
            SizedBox(height: 8),
            Text('Company Name: Company Name $jobId'),
            SizedBox(height: 8),
            Text('Location: Location $jobId'),
            SizedBox(height: 8),
            Text('Salary Range: Salary Range $jobId'),
            SizedBox(height: 8),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
