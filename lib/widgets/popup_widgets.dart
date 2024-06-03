import 'package:devproj/models/projects_model.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/repositories/project_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showAddPostOptions(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Project'),
              onTap: () {
                showAddProjectDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Job'),
              onTap: () {
                showAddJobDialog(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showAddProjectDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fundsController = TextEditingController();
  String projectType = 'Company Project';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Add Project',
          style: TextStyle(color: AppColors.darkBlue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: AppColors.darkBlue),
              ),
              style: const TextStyle(color: AppColors.darkBlue),
            ),
            DropdownButtonFormField<String>(
              value: projectType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  projectType = newValue;
                }
              },
              items: <String>[
                'Company Project',
                'FYP',
                'Personal Project',
                'Course Project'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: AppColors.darkBlue)),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Type',
                hintStyle: TextStyle(color: AppColors.darkBlue),
              ),
              style: const TextStyle(color: AppColors.darkBlue),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: AppColors.darkBlue),
              ),
              style: const TextStyle(color: AppColors.darkBlue),
            ),
            TextField(
              controller: fundsController,
              decoration: const InputDecoration(
                hintText: 'Funds Required',
                hintStyle: TextStyle(color: AppColors.darkBlue),
              ),
              style: const TextStyle(color: AppColors.darkBlue),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: AppColors.darkBlue)),
          ),
          TextButton(
            onPressed: () {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                String title = titleController.text;
                String description = descriptionController.text;
                String funds = fundsController.text;

                if (title.isNotEmpty && projectType.isNotEmpty) {
                  Project newProject = Project(
                    createdBy: user.uid,
                    title: title,
                    type: projectType,
                    description: description,
                    funds: funds,
                  );

                  ProjectService().addProject(newProject);
                }
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add', style: TextStyle(color: AppColors.darkBlue)),
          ),
        ],
      );
    },
  );
}

void showAddJobDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController _jobController = TextEditingController();
      return AlertDialog(
        title: const Text('Add Job'),
        content: TextField(
          controller: _jobController,
          decoration: const InputDecoration(hintText: 'Job details...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String jobDetails = _jobController.text;
              if (jobDetails.isNotEmpty) {
                // Add job to Firestore or any other storage
                // For example:
                // FirebaseFirestore.instance.collection('jobs').add({
                //   'details': jobDetails,
                //   'timestamp': Timestamp.now(),
                //   'userId': user!.uid,
                // });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

