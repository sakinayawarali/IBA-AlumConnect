import 'package:flutter/material.dart';
import 'package:devproj/theme/app_colours.dart';

class ViewProfileScreen extends StatelessWidget {
  final UserProfile userProfile; // Pass the user profile data here

  ViewProfileScreen({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
        backgroundColor: AppColors.darkGrey,
      ),
      backgroundColor: AppColors.darkGrey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${userProfile.firstName} ${userProfile.lastName}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Employment Status: ${userProfile.employmentStatus}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Location: ${userProfile.location}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Interests: ${userProfile.interests}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Program: ${userProfile.program}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Graduation Batch: ${userProfile.graduationBatch}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'LinkedIn: ${userProfile.linkedIn}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: ${userProfile.email}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone: ${userProfile.phone}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Job History: ${userProfile.jobHistory}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String employmentStatus;
  final String location;
  final String interests;
  final String program;
  final String graduationBatch;
  final String linkedIn;
  final String email;
  final String phone;
  final String jobHistory;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.employmentStatus,
    required this.location,
    required this.interests,
    required this.program,
    required this.graduationBatch,
    required this.linkedIn,
    required this.email,
    required this.phone,
    required this.jobHistory,
  });
}
