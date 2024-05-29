// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:devproj/theme/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

 @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      appBar: AppBar(
        backgroundColor: AppColors.darkGrey,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.darkGrey,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                accountName: Text("Abhishek Mishra",
                    style: TextStyle(
                        fontFamily: 'Helvetica', color: Colors.white)),
                accountEmail: Text("abhishekm977@gmail.com",
                    style: TextStyle(
                        fontFamily: 'Helvetica', color: Colors.white)),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  child: Text("A",
                      style: TextStyle(
                          fontFamily: 'Helvetica', color: Colors.white)),
                ),
              ), //Text
            ), //circleAvatar
            //UserAccountDrawerHeader
            //DrawerHeader
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: const Text(
                ' View Profile',
                style: TextStyle(fontFamily: 'Helvetica', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.question_mark,
                color: Colors.white,
              ),
              title: const Text(
                ' Help Center',
                style: TextStyle(fontFamily: 'Helvetica', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text(
                ' Settings',
                style: TextStyle(fontFamily: 'Helvetica', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                ' Logout',
                style: TextStyle(fontFamily: 'Helvetica', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      //Drawer
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.darkGrey,
        color: AppColors.lightGreen,
        buttonBackgroundColor: AppColors.lightGreen,
        height: 50, // Adjust as needed
        index: _selectedIndex,
        items: [
          Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.people,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.message,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Helvetica'),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      child: Container(
                        color: AppColors.lightBlue,
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust card width as needed
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Center(
                          child: Text(
                            "Card 1",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        color: AppColors.lightBlue,
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust card width as needed
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Center(
                          child: Text(
                            "Card 1",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        color: AppColors.lightBlue,
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust card width as needed
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Center(
                          child: Text(
                            "Card 1",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        color: AppColors.lightBlue,
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust card width as needed
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Center(
                          child: Text(
                            "Card 1",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(
                      0, 0, 0, 0.2), // Adjust opacity level as needed
                ),
                child: Column(
                  children: [
                    buildRowWithButton('FYP Showcase', 'View'),
                    SizedBox(height: 10),
                    buildRowWithButton('Job Board', 'View'),
                    SizedBox(height: 10),
                    buildRowWithButton('Mentorships', 'View'),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
  padding: EdgeInsets.only(bottom: 30), // Adjust the bottom padding as needed
  child: Expanded(
    child: Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: FloatingActionBubble(     
          items: <Bubble>[
            Bubble(
              icon: Icons.post_add,
              iconColor: Colors.white,
              title: 'Add FYP',
              titleStyle: TextStyle(fontFamily: 'Helvetica'),
              bubbleColor: AppColors.red,
              onPress: () {},
            ),
            Bubble(
              icon: Icons.event,
              iconColor: Colors.white,
              title: 'Add Event',
              titleStyle: TextStyle(fontFamily: 'Helvetica'),
              bubbleColor: AppColors.red,
              onPress: () {},
            ),
          ],
          onPress: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          },
          iconData: Icons.add,
          iconColor: Colors.white,
          backGroundColor: Colors.black,
          animation: _animation,
        ),
      ),
    ),
  ),
              ),
              
            ],
          
          ),
      
        
        ),
      ),
    );
  }
}
