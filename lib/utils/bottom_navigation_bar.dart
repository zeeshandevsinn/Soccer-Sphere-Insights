// import 'dart:async';

// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:app4_6_8/baske.dart';
// import 'package:app4_6_8/footnews.dart';
// import 'package:app4_6_8/leagueshow.dart';
// import 'package:app4_6_8/new_road_map/dashboard_screen.dart';
// import 'package:app4_6_8/newlivematch.dart';
// import 'package:app4_6_8/vidoesfot.dart';
// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   var _bottomNavIndex = 0; // default index of the first screen

//   late AnimationController _borderRadiusAnimationController;
//   late Animation<double> borderRadiusAnimation;
//   late CurvedAnimation borderRadiusCurve;
//   late AnimationController _hideBottomBarAnimationController;

//   final iconList = <IconData>[
//     Icons.home_filled,
//     // Icons.sports_soccer,
//     Icons.live_tv,
//     Icons.article,
//     Icons.leaderboard,
//     Icons.sports_basketball,
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _borderRadiusAnimationController = AnimationController(
//       duration: Duration(milliseconds: 500),
//       vsync: this,
//     );
//     borderRadiusCurve = CurvedAnimation(
//       parent: _borderRadiusAnimationController,
//       curve: Interval(1.0, 1.0, curve: Curves.fastLinearToSlowEaseIn),
//     );

//     borderRadiusAnimation =
//         Tween<double>(begin: 0, end: 1).animate(borderRadiusCurve);

//     _hideBottomBarAnimationController = AnimationController(
//       duration: Duration(milliseconds: 200),
//       vsync: this,
//     );

//     Future.delayed(
//         Duration(seconds: 1), () => _borderRadiusAnimationController.forward());
//   }

//   bool onScrollNotification(ScrollNotification notification) {
//     if (notification is UserScrollNotification &&
//         notification.metrics.axis == Axis.vertical) {
//       switch (notification.direction) {
//         case ScrollDirection.forward:
//           _hideBottomBarAnimationController.reverse();
//           break;
//         case ScrollDirection.reverse:
//           _hideBottomBarAnimationController.forward();
//           break;
//         case ScrollDirection.idle:
//           break;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: onScrollNotification,
//         child: NavigationScreen(iconList[_bottomNavIndex], _bottomNavIndex),
//       ),
//       bottomNavigationBar: AnimatedBottomNavigationBar.builder(
//         itemCount: iconList.length,
//         tabBuilder: (int index, bool isActive) {
//           final color = isActive ? Colors.deepOrange : Colors.grey.shade300;
//           return Column(
//             // mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Icon(
//                 iconList[index],
//                 size: 24,
//                 color: color,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 [
//                   "Home",
//                   // "Leagues",
//                   "Live Match",
//                   "News",
//                   "Highlights",
//                   "BasketBall"
//                 ][index],
//                 maxLines: 1,
//                 style: TextStyle(color: color),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           );
//         },
//         backgroundColor: const Color.fromARGB(255, 51, 49, 49),
//         activeIndex: _bottomNavIndex,
//         splashColor: Colors.black,
//         // notchAndCornersAnimation: borderRadiusAnimation,
//         // splashSpeedInMilliseconds: 300,
//         notchSmoothness: NotchSmoothness.defaultEdge,
//         onTap: (index) => setState(() => _bottomNavIndex = index),
//         // hideAnimationController: _hideBottomBarAnimationController,
//         shadow: BoxShadow(
//           offset: Offset(0, 1),
//           blurRadius: 12,
//           spreadRadius: 0.5,
//           color: Color(0xff000000),
//         ),
//       ),
//     );
//   }
// }

// class NavigationScreen extends StatefulWidget {
//   final IconData iconData;
//   var index;

//   NavigationScreen(this.iconData, this.index) : super();

//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> animation;

//   @override
//   void didUpdateWidget(NavigationScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.iconData != widget.iconData) {
//       _startAnimation();
//     }
//   }

//   @override
//   void initState() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//     );
//     animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );
//     _controller.forward();
//     super.initState();
//   }

//   _startAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//     );
//     animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _pages[widget.index];
//     // CircularRevealAnimation(
//     //     animation: animation,
//     //     centerOffset: Offset(80, 80),
//     //     maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
//     //     child: DashboardScreen());
//   }
// }

import 'package:app4_6_8/baske.dart';
import 'package:app4_6_8/footnews.dart';
import 'package:app4_6_8/new_road_map/dashboard_screen.dart';
import 'package:app4_6_8/newlivematch.dart';
import 'package:app4_6_8/vidoesfot.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<Widget> _pages = <Widget>[
    DashboardScreen(),
    SoccerHighlightsScreen(),
    BasketballTeamsPage(),
  ];
  var _bottomNavIndex = 0; // default index of the first screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 2.0, color: Colors.deepOrange),
          ),
          color: const Color.fromARGB(255, 51, 49, 49),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 12,
              spreadRadius: 0.5,
              color: Color(0xff000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_filled),
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = 0;
                  });
                },
                color: _bottomNavIndex == 0
                    ? Colors.deepOrange
                    : Colors.grey.shade300,
              ),
              IconButton(
                icon: Icon(Icons.leaderboard),
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = 1;
                  });
                },
                color: _bottomNavIndex == 1
                    ? Colors.deepOrange
                    : Colors.grey.shade300,
              ),
              IconButton(
                icon: Icon(Icons.sports_basketball),
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = 2;
                  });
                },
                color: _bottomNavIndex == 2
                    ? Colors.deepOrange
                    : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
