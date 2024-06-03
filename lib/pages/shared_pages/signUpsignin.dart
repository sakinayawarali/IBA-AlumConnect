import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/pages/shared_pages/complete_profile.dart';
import 'package:devproj/pages/shared_pages/home_screen.dart';
import 'package:devproj/pages/shared_pages/welcome_screen.dart';
import 'package:devproj/utils/auth.dart';
import 'package:devproj/pages/shared_pages/validation.dart';
import 'package:devproj/widgets/popup_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/widgets/form_widgets.dart';
import 'package:devproj/theme/app_fonts.dart';
import 'package:devproj/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentSignUpSignIn extends StatefulWidget {
  final String userType;
  const StudentSignUpSignIn({Key? key, required this.userType})
      : super(key: key);

  @override
  _StudentSignUpSignInState createState() => _StudentSignUpSignInState();
}

class _StudentSignUpSignInState extends State<StudentSignUpSignIn> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: const TabBar(
            tabs: [
              CustomTab(title: 'Sign Up'),
              CustomTab(title: 'Login'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SignUpScreenContainer(userType: widget.userType),
            LoginScreenContainer(userType: widget.userType),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String title;
  const CustomTab({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        style: AppStyles.tabTextStyle,
      ),
    );
  }
}

class SignUpScreenContainer extends ConsumerStatefulWidget {
  final String userType;

  const SignUpScreenContainer({Key? key, required this.userType})
      : super(key: key);

  @override
  _SignUpScreenContainerState createState() => _SignUpScreenContainerState();
}

class _SignUpScreenContainerState extends ConsumerState<SignUpScreenContainer> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 20),
      ),
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Sign Up', style: AppStyles.headingTextStyle),
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Email',
                        validator: (value) => value?.isNotEmpty ?? false
                            ? null
                            : "Email cannot be empty",
                        onSaved: (value) => email = value,
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Password',
                        obscureText: true,
                        isPasswordVisible: _isPasswordVisible,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          } else if (!(isValidPassword(value))) {
                            return "Password must contain at least 8 characters, including upper/lowercase, number, and special character";
                          }
                          return password;
                        },
                        onSaved: (value) => password = value,
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Confirm Password',
                        obscureText: true,
                        isPasswordVisible: _isPasswordVisible,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          } else if (!(doPasswordsMatch(
                              password ?? '', confirmPassword ?? ''))) {
                            return "Passwords do not match";
                          }
                          return confirmPassword;
                        },
                        onSaved: (value) => confirmPassword = value,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(
                            (MediaQuery.of(context).size.width * 0.5),
                            (MediaQuery.of(context).size.height * 0.07),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            Auth.handleSignUp(widget.userType, email, password,
                                () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompleteProfilePage(
                                      userType: widget.userType,
                                      user: FirebaseAuth.instance.currentUser!),
                                ),
                              );
                            });
                          } else {
                            showErrorDialog(context,
                                'Error Signing Up. Please check your form.');
                          }
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        "or Connect with Google",
                        style: AppStyles.googleButtonTextStyle,
                      ),
                      const SizedBox(height: 15.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          Auth.signInWithGoogle(context, widget.userType)
                              .then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google_logo.png',
                              height: 24.0,
                              width: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Have an account? ',
                            style: AppStyles.richTextStyle,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Log in',
                                style: AppStyles.richTextBoldStyle.copyWith(
                                  color: AppColors.lightTeal,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    DefaultTabController.of(context)
                                        ?.animateTo(1);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 2,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenContainer extends StatefulWidget {
  final String userType;

  const LoginScreenContainer({Key? key, required this.userType})
      : super(key: key);

  @override
  _LoginScreenContainerState createState() => _LoginScreenContainerState();
}

class _LoginScreenContainerState extends State<LoginScreenContainer> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 20),
      ),
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Email',
                        validator: (value) => value?.isNotEmpty ?? false
                            ? null
                            : "Email cannot be empty",
                        onSaved: (value) => email = value?.trim(),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Password',
                        obscureText: true,
                        isPasswordVisible: _isPasswordVisible,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) => password = value,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(
                            (MediaQuery.of(context).size.width * 0.5),
                            (MediaQuery.of(context).size.height * 0.07),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            try {
                              QuerySnapshot userQuery = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .where('email', isEqualTo: email)
                                  .limit(1)
                                  .get();

                              if (userQuery.docs.isEmpty) {
                                showErrorDialog(context,
                                    'No account found for this email.');
                              } else {
                                await Auth.signInWithEmailPassword(
                                    email!, password!);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (e is FirebaseAuthException) {
                                if (e.code == 'wrong-password') {
                                  showErrorDialog(context,
                                      'Incorrect password. Please try again.');
                                } else {
                                  showErrorDialog(context,
                                      'Error logging in. Please check your form.');
                                }
                              } else {
                                showErrorDialog(context,
                                    'Error logging in. Please check your form.');
                              }
                            }
                          } else {
                            showErrorDialog(context,
                                'Error Logging In. Please check your form.');
                          }
                        },
                        child: const Text('Login',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        "or Connect with Google",
                        style: AppStyles.googleButtonTextStyle,
                      ),
                      const SizedBox(height: 15.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await Auth.signInWithGoogle(context, widget.userType);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google_logo.png',
                              height: 24.0,
                              width: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: AppStyles.richTextStyle,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: AppStyles.richTextBoldStyle.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    DefaultTabController.of(context)
                                        ?.animateTo(0);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
