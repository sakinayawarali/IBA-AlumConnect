import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/pages/shared_pages/all_projects.dart';
import 'package:devproj/pages/shared_pages/my_jobs.dart';
import 'package:devproj/pages/shared_pages/my_projects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devproj/pages/shared_pages/complete_profile.dart';
import 'package:devproj/pages/shared_pages/inbox.dart';
import 'package:devproj/pages/shared_pages/job_listings.dart';
import 'package:devproj/pages/shared_pages/search_directory.dart';
import 'package:devproj/pages/shared_pages/view_calendar.dart';
import 'package:devproj/pages/shared_pages/view_network.dart';
import 'package:devproj/pages/shared_pages/view_profile.dart';
import 'package:devproj/pages/shared_pages/welcome_screen.dart';
import 'package:devproj/theme/app_animation.dart';
import 'package:devproj/theme/app_fonts.dart';
import 'package:devproj/utils/auth.dart';
import 'package:devproj/widgets/button_widgets.dart';
import 'package:devproj/widgets/popup_widgets.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:devproj/theme/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Auth auth = Auth();
  var user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
        actions: [
        ],
      ),
      drawer: buildDrawer(),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        onPressed: () => showAddPostOptions(context),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.red,
      ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: Colors.black,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Handle navigation based on index
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewNetworkPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewEventsScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InboxScreen()),
              );
              break;
          }
        },
        items: [
          FlashyTabBarItem(
            icon: IconStyles.smallIcon(Icons.home),
            title: const Text(
              'Home',
              style: AppStyles.smallerText,
            ),
          ),
          FlashyTabBarItem(
            icon: IconStyles.smallIcon(Icons.people_alt_outlined),
            title: const Text(
              'Network',
              style: AppStyles.smallerText,
            ),
          ),
          FlashyTabBarItem(
            icon: IconStyles.smallIcon(Icons.calendar_month),
            title: const Text(
              'Calendar',
              style: AppStyles.smallerText,
            ),
          ),
          FlashyTabBarItem(
            icon: IconStyles.smallIcon(Icons.message_outlined),
            title: const Text(
              'Inbox',
              style: AppStyles.smallerText,
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent, // Remove the box behind
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.school, // Icon related to education or graduation
                    color: AppColors.darkBlue,
                    size: 40.0,
                  ),
                  const SizedBox(height: 8.0),
                  if (user?.displayName != null &&
                      user!.displayName!.isNotEmpty)
                    Text(
                      '${user?.displayName ?? ""}',
                      style: AppStyles.richTextStyle,
                    ),
                    Flexible(child: Text(
                    '${user?.email ?? ""}',
                    style: AppStyles.richTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ),
                ],
              ),
            ),
          ),
          buildListTile(Icons.person, 'View Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewProfilePage(),
              ),
            );
          }),
          buildListTile(Icons.question_mark, 'Help Center', () {
            Navigator.pop(context);
          }),
          buildListTile(Icons.settings, 'Settings', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }),
          buildListTile(Icons.logout, 'Logout', () {
            Auth.signOutCurrentUser(context);
          }),
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.darkBlue,
      ),
      title: Text(
        title,
        style: AppStyles.richTextStyle,
      ),
      onTap: onTap,
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearchField(context),
              const SizedBox(height: 20),
              Row(
                children: [Text('Explore', style: AppStyles.mediumHeading)],
              ),
              const SizedBox(height: 20),
              buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchDirectoryPage(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 48.0,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8.0),
            Text(
              'Search...',
              style: AppStyles.smallerText.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        buildGridItem(
          context,
          'View Projects',
          Icons.book,
          MyProjectsScreen(),
        ),
        buildGridItem(
          context,
          'Job Board',
          Icons.work_sharp,
          JobListingScreen(),
        ),
        buildGridItemWithMenu(
          context,
          'View Your Postings',
          Icons.post_add,
        ),
      ],
    );
  }

  Widget buildGridItem(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 1),
        ),
        color: AppColors.lightBlue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppStyles.smallerText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridItemWithMenu(
      BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.article),
                  title: Text('My Projects'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherProjectsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.article_outlined),
                  title: Text('My Jobs'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyJobsScreen()),
                    );
                  },
                ),
                
              ],
            );
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 1),
        ),
        color: AppColors.lightBlue,
        child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppStyles.smallerText,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
