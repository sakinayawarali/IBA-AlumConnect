import 'package:flutter/material.dart';

class FYPListingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FYP Listings'),
      ),
      body: ListView.builder(
        itemCount: fypList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(fypList[index].title),
            subtitle: Text(fypList[index].description),
            onTap: () {
              // Navigate to FYP details screen
            },
          );
        },
      ),
    );
  }
}

// Model class for FYP
class FYP {
  final String title;
  final String description;

  FYP({required this.title, required this.description});
}

// Dummy data for FYP listings (replace with actual data)
List<FYP> fypList = [
  FYP(
    title: 'Automated Attendance System using Facial Recognition',
    description:
        'A system for automated attendance tracking using facial recognition technology.',
  ),
  FYP(
    title: 'Smart Agriculture Monitoring System',
    description:
        'An IoT-based solution for monitoring and controlling agricultural parameters.',
  ),
  FYP(
    title: 'Online Learning Platform for Vocational Training',
    description: 'A platform for providing vocational training courses online.',
  ),
  // Add more FYP objects as needed
];
