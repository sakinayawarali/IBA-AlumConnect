// ignore_for_file: sort_child_properties_last
import 'package:devproj/pages/student_pages/student_home.dart';
import 'package:devproj/pages/student_pages/student_signup.dart';
import 'package:devproj/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<UserCredential?> userCredential = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            SizedBox(
              child: Image.asset(
                  'assets/logo/alumconnect-high-resolution-logo-transparent.png'),
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(height: 50),
            const Text(
              'LOG IN',
              style: TextStyle(
                fontFamily: 'Helvetica',
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontFamily: 'Helvetica',
                      ),
                      hintText: 'Enter your Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontFamily: 'Helvetica'),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      // Styled Google sign-in button
                      onPressed: () async {
                        try {
                          UserCredential? credential = await signInWithGoogle();
                          if (credential != null) {
                            userCredential.value = credential;
                            void saveLoginStatus(bool status) {
                              // Your code to save the login status goes here
                            }
                            print(
                                FirebaseAuth.instance.currentUser?.displayName);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          }
                        } catch (e) {
                          // Handle sign-in error
                          print('Sign-in error: $e');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/google_logo.png',
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 173, 181, 1),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'LOG IN',
                      style: TextStyle(
                        fontFamily: 'Helevtica',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromRGBO(0, 173, 181, 1),
                      side: const BorderSide(
                          color: Color.fromRGBO(0, 173, 181, 1)),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(42),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Color(0xff008955),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInScreen extends StatelessWidget {
  final ValueNotifier<UserCredential?> userCredential;

  const GoogleSignInScreen({Key? key, required this.userCredential})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = userCredential.value?.user;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            // Display user profile picture in a circle avatar
            backgroundImage: NetworkImage(user?.photoURL.toString() ?? ''),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Text(
            user?.displayName.toString() ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            user?.email.toString() ?? '',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              bool result = await signOutFromGoogle();
              if (result) userCredential.value = null;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Logout button color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
