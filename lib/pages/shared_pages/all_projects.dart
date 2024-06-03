import 'package:devproj/models/projects_model.dart';
import 'package:devproj/repositories/project_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtherProjectsScreen extends StatefulWidget {
  @override
  _OtherProjectsScreenState createState() => _OtherProjectsScreenState();
}

class _OtherProjectsScreenState extends State<OtherProjectsScreen> {
  final ProjectService projectService = ProjectService();
  User? user = FirebaseAuth.instance.currentUser;
  List<Project> otherProjects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    if (user != null) {
      List<Project> projects = await projectService.getAllProjects();
      setState(() {
        otherProjects = projects
            .where((project) => project.createdBy != user!.uid)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Projects'),
      ),
      body: otherProjects.isEmpty
          ? Center(child: Text('No projects found'))
          : ListView.builder(
              itemCount: otherProjects.length,
              itemBuilder: (context, index) {
                Project project = otherProjects[index];
                return ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.description),
                  onTap: () {
                    // Handle project tap if needed
                  },
                );
              },
            ),
    );
  }
}
