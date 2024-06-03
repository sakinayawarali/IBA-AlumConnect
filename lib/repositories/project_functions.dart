import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/projects_model.dart';

class ProjectService {
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('projects');

  // Create a new project
  Future<void> addProject(Project project) async {
    try {
      await projectCollection.add(project.toJson());
      print("Project successfully added!");
    } catch (error) {
      print("Error adding project: $error");
    }
  }

  // Read a project by ID
  Future<Project?> getProjectById(String id) async {
    try {
      DocumentSnapshot doc = await projectCollection.doc(id).get();
      if (doc.exists) {
        return Project.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print("Error getting project: $error");
    }
    return null;
  }

  // Read all projects
  Future<List<Project>> getAllProjects() async {
    try {
      QuerySnapshot querySnapshot = await projectCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              Project.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print("Error getting projects: $error");
      return [];
    }
  }

  // Update a project by ID
  Future<void> updateProject(String id, Project project) async {
    try {
      await projectCollection.doc(id).update(project.toJson());
      print("Project successfully updated!");
    } catch (error) {
      print("Error updating project: $error");
    }
  }

  // Delete a project by ID
  Future<void> deleteProject(String id) async {
    try {
      await projectCollection.doc(id).delete();
      print("Project successfully deleted!");
    } catch (error) {
      print("Error deleting project: $error");
    }
  }
}
