import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class MyHomePageState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget buildFloatingActionButton() {
    return FloatingActionBubble(
      items: <Bubble>[
        Bubble(
          title: "Action 1",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.add,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            // Handle Action 1
          },
        ),
        Bubble(
          title: "Action 2",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.edit,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            // Handle Action 2
          },
        ),
        Bubble(
          title: "Action 3",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.delete,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            // Handle Action 3
          },
        ),
      ],
      onPress: () {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      },
      iconColor: Colors.white,
      iconData: Icons.menu,
      backGroundColor: Colors.blue,
      animation: animation, // Pass the animation to the FAB
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Existing code...
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}
