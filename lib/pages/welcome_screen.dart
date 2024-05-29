// ignore_for_file: prefer_const_constructors
import 'package:devproj/pages/login_screen.dart';
import 'package:devproj/pages/student_pages/student_signup.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10),
                      child: Image.asset(
                        'assets/icons/74-College-graduation (3).png',
                        scale: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black),
                            fixedSize: Size(
                              (MediaQuery.of(context).size.width * 0.75),
                              (MediaQuery.of(context).size.height * 0.07),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Alumni',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              color: Color.fromRGBO(19, 0, 90, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(19, 0, 90, 1),
                            side: BorderSide(color: Colors.black),
                            fixedSize: Size(
                              (MediaQuery.of(context).size.width * 0.75),
                              (MediaQuery.of(context).size.height * 0.07),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Student',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "By signing up you accept the Terms of Service and Privacy Policy.",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
