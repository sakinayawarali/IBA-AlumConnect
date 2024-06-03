import 'package:devproj/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authServiceProvider = Provider<Auth>((ref) {
  return Auth();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return Auth.authStateChanges();
});
