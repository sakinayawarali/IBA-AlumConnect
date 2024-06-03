// ignore_for_file: prefer_const_constructors
import 'package:devproj/pages/shared_pages/splash_screen.dart';
import 'package:devproj/pages/shared_pages/welcome_screen.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/utils/auth.dart';
import 'package:devproj/repositories/notifications_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core package
import 'package:devproj/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize the local notifications
  NotificationService().initialize();

  // Start monitoring Firestore changes
  FirestoreService().monitorMessages();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlumConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkGrey),
        useMaterial3: true,
        textTheme: GoogleFonts.ralewayTextTheme(),
        scaffoldBackgroundColor: AppColors.white, ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(imageSrc: 'assets/logos/alumconnect-high-resolution-logo-transparent.png',),
    );
  }
}
