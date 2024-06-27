import 'package:flutter/material.dart';
import 'dart:math';

class DrawerMainScreen extends StatefulWidget {
  const DrawerMainScreen({super.key});

  @override
  State<DrawerMainScreen> createState() => _DrawerMainScreenState();
}

class _DrawerMainScreenState extends State<DrawerMainScreen> {
  double value = 0;

  void toggleDrawer() {
    setState(() {
      value == 0 ? value = 1 : value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade800],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: 200,
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.black,
                        ),
                        Text(
                          "Some Where",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("3D Drawer"),
                    leading: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (details.primaryDelta! > 0) {
                          toggleDrawer();
                        } else if (details.primaryDelta! < 0) {
                          toggleDrawer();
                        }
                      },
                      onTap: () {
                        toggleDrawer();
                      },
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: toggleDrawer,
                      ),
                    ),
                  ),
                  body: Center(
                    child: Text("Swipe Right to open the menu"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
