import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/theme/app_fonts.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

Widget buildRowWithButton(BuildContext context, String text, String buttonText,
    Widget destinationPage) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: AppStyles.normalText,),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the destination page when button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destinationPage),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.darkBlue),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Helvetica'),
          ),
        ),
      ],
    ),
  );
}

Widget buildInfoBox(BuildContext context, String title, String buttonText,
    IconData iconData, Widget screen, Size size) {
  return Material(
    elevation: 10,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                iconData,
                color: AppColors.darkTeal,
                size: 36,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    title,
                    style: AppStyles.mediumHeading,
                  ),
              ],),
            ],
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.blue,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildFloatingActionButton(),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Action 1",
              iconColor: Colors.white,
              bubbleColor: AppColors.red,
              icon: Icons.add,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                // Handle Action 1
              },
            ),
            Bubble(
              title: "Action 2",
              iconColor: Colors.white,
              bubbleColor: AppColors.red,
              icon: Icons.edit,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                // Handle Action 2
              },
            ),
            Bubble(
              title: "Action 3",
              iconColor: Colors.white,
              bubbleColor: AppColors.red,
              icon: Icons.delete,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                // Handle Action 3
              },
            ),
          ],
          onPress: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          },
          iconColor: Colors.white,
          iconData: Icons.menu,
          backGroundColor: AppColors.red,
          animation: _animationController,
        );
      },
    );
  }
}

