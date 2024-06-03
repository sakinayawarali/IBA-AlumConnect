import 'package:devproj/models/projects_model.dart';
import 'package:devproj/repositories/project_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyProjectsScreen extends StatefulWidget {
  @override
  _MyProjectsScreenState createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  final ProjectService projectService = ProjectService();
  User? user = FirebaseAuth.instance.currentUser;
  List<Project> myProjects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    if (user != null) {
      List<Project> projects = await projectService.getAllProjects();
      setState(() {
        myProjects = projects
            .where((project) => project.createdBy == user!.uid)
            .toList();
      });
    }
  }

  void _editProject(Project project) async {
    TextEditingController titleController =
        TextEditingController(text: project.title);
    TextEditingController descriptionController =
        TextEditingController(text: project.description);
    TextEditingController fundsController =
        TextEditingController(text: project.funds);
    TextEditingController typeController =
        TextEditingController(text: project.type);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Project'),
        content: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            TextField(
                controller: fundsController,
                decoration: InputDecoration(labelText: 'Funds')),
            TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Project updatedProject = Project(
                createdBy: project.createdBy,
                title: titleController.text,
                description: descriptionController.text,
                funds: fundsController.text,
                type: typeController.text,
              );
              await projectService.updateProject(project.createdBy, updatedProject);
              Navigator.of(context).pop();
              _loadProjects();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteProject(String id) async {
    await projectService.deleteProject(id);
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Projects'),
      ),
      body: myProjects.isEmpty
          ? Center(child: Text('No projects found'))
          : ListView.builder(
              itemCount: myProjects.length,
              itemBuilder: (context, index) {
                Project project = myProjects[index];
                return ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProject(project),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProject(project.createdBy!),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
