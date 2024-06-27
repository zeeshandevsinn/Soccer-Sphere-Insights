import 'package:app4_6_8/new_road_map/splash_screen.dart';
import 'package:app4_6_8/utils/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "GoalPost Details",
        // theme: MyTheme.theme,
        home: SplashScreen());
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _controller;

//   static List<Widget> _pages = <Widget>[
//     LeagueSelectionPage(),
//     LiveFootballScoresPage(),
//     SoccerNewsScreen(),
//     SoccerHighlightsScreen(),
//     BasketballTeamsPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _showPopup(String label) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(label),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _pages.elementAt(_selectedIndex),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: CurvedBottomBar(
//               selectedIndex: _selectedIndex,
//               onItemTapped: _onItemTapped,
//               controller: _controller,
//               showPopup: _showPopup,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CurvedBottomBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//   final AnimationController controller;
//   final Function(String) showPopup;

//   CurvedBottomBar({
//     required this.selectedIndex,
//     required this.onItemTapped,
//     required this.controller,
//     required this.showPopup,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       shape: CircularNotchedRectangle(),
//       notchMargin: 6.0,
//       child: ClipPath(
//         clipper: BottomBarClipper(),
//         child: Container(
//           height: 75,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.lightBlueAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 spreadRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildAnimatedIcon(Icons.sports_soccer, 'Leagues', 0),
//               _buildAnimatedIcon(Icons.sports, 'Live Match', 1),
//               _buildAnimatedIcon(Icons.article, 'News', 2),
//               _buildAnimatedIcon(Icons.video_collection, 'Highlights', 3),
//               _buildAnimatedIcon(Icons.sports_basketball, 'Basketball', 4),
//             ],
//           ),
//         ),
//       ),
//       color: Colors.transparent,
//       elevation: 20,
//     );
//   }

//   Widget _buildAnimatedIcon(IconData icon, String label, int index) {
//     return GestureDetector(
//       onTap: () {
//         onItemTapped(index);
//         showPopup(label);
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           AnimatedBuilder(
//             animation: controller,
//             builder: (context, child) {
//               double scale = selectedIndex == index ? 1.5 : 1.0;
//               return Transform.scale(
//                 scale: 0.8 + (controller.value * 0.2),
//                 child: Icon(
//                   icon,
//                   color: selectedIndex == index ? Colors.white : Colors.white70,
//                   size: 30 * scale,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomBarClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, 0);
//     path.lineTo(0, size.height - 20);
//     path.quadraticBezierTo(
//         size.width / 2, size.height + 30, size.width, size.height - 20);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
