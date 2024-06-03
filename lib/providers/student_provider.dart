import 'package:devproj/models/users_models/alumni_model.dart';
import 'package:devproj/models/users_models/student_model.dart';
import 'package:devproj/utils/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devproj/repositories/student_repository.dart' as student_repository;
import 'package:devproj/repositories/alumni_repository.dart' as alumni_repository;

// Provider for user type
final userTypeProvider =
    FutureProvider.family<String, String>((ref, userId) async {
  return await getUserType(userId);
});

// Provider for student details
final studentProvider =
    FutureProvider.family<Student?, String>((ref, userId) async {
  return await student_repository.StudentCRUD().readStudentById(userId);
});

// Provider for alumni details
final alumniProvider =
    FutureProvider.family<Alumni?, String>((ref, userId) async {
  return await  alumni_repository.AlumniCRUD().readAlumniById(userId);
});
