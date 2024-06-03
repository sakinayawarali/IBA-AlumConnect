// welcome_screen.dart
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:carousel_slider/carousel_slider.dart';
import 'package:devproj/pages/shared_pages/signUpsignin.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userType = ''; // Alumni or Student

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildWelcomeImage(),
              SizedBox(height: 30),
              _buildCarousel(),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Started",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_downward,
                    color: AppColors.darkBlue,
                    size: 24,
                  ),
                ],
              ),
              _buildWelcomeButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: <Widget>[
        Container(
          color: AppColors.red,
          child: Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.red,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Reconnect,\nReminisce,\nRejoice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.red,
          child: Center(
            child: Text(
              'Join us in celebrating our shared journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
         Container(
          color: AppColors.red,
          child: Center(
            child: Text(
              'Connect with your peers to acheive something magical',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeImage() {
    return Image.asset(
      'assets/logos/alumconnect-high-resolution-logo-transparent.png',
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
    );
  }

  Widget _buildWelcomeButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25.0),
          _buildWelcomeButton(
            context,
            text: 'Alumni',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            pressedColor: AppColors.darkTeal,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentSignUpSignIn(userType: 'alumni'),
                ),
              );
            },
          ),
          SizedBox(height: 15.0),
          _buildWelcomeButton(
            context,
            text: 'Student',
            backgroundColor: const Color(0xFF029687),
            textColor: Colors.white,
            pressedColor: AppColors.darkTeal,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentSignUpSignIn(userType: 'student'),
                ),
              );
            },
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildWelcomeButton(
    BuildContext context, {
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color pressedColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(color: Colors.black),
        fixedSize: Size(
          (MediaQuery.of(context).size.width * 0.7),
          (MediaQuery.of(context).size.height * 0.07),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          color: textColor,
          decoration: TextDecoration.underline,
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(pressedColor),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
