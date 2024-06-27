import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';

class DrawerBlackBox extends StatefulWidget {
  @override
  State<DrawerBlackBox> createState() => _DrawerBlackBoxState();
}

class _DrawerBlackBoxState extends State<DrawerBlackBox> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FootBall King App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Text('Get Started'),
        ),
      ),
      endDrawer: CustomDrawer(),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/drawer_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'FootBall King App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              leading: AnimatedIconButton(
                size: 24.0,
                onPressed: () {},
                duration: Duration(milliseconds: 500),
                icons: [
                  AnimatedIconItem(
                      icon: Icon(
                        Icons.favorite,
                      ),
                      tooltip: "Favorites")
                ],
              ),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: AnimatedIconButton(
                size: 24.0,
                onPressed: () {},
                duration: Duration(milliseconds: 500),
                icons: [
                  AnimatedIconItem(
                      icon: Icon(
                        Icons.favorite,
                      ),
                      tooltip: "Favorites")
                ],
              ),
              title: Text('Favorites'),
              onTap: () {},
            ),
            ListTile(
              leading: AnimatedIconButton(
                size: 24.0,
                onPressed: () {},
                duration: Duration(milliseconds: 500),
                icons: [
                  AnimatedIconItem(
                      icon: Icon(
                        Icons.settings,
                      ),
                      tooltip: "Settings")
                ],
              ),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: AnimatedIconButton(
                size: 24.0,
                onPressed: () {},
                duration: Duration(milliseconds: 500),
                icons: [
                  AnimatedIconItem(
                      icon: Icon(
                        Icons.info,
                      ),
                      tooltip: "About")
                ],
              ),
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: AnimatedIconButton(
                size: 24.0,
                onPressed: () {},
                duration: Duration(milliseconds: 500),
                icons: [
                  AnimatedIconItem(
                      icon: Icon(
                        Icons.logout,
                      ),
                      tooltip: "Log out")
                ],
              ),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           _createHeader(),
//           _createDrawerItem(icon: Icons.home, text: 'Home'),
//           _createDrawerItem(icon: Icons.settings, text: 'Settings'),
//           _createDrawerItem(icon: Icons.info, text: 'About'),
//           _createDrawerItem(icon: Icons.help, text: 'Help'),
//           _createDrawerItem(icon: Icons.logout, text: 'Logout'),
//         ],
//       ),
//     );
//   }

//   Widget _createHeader() {
//     return DrawerHeader(
//       margin: EdgeInsets.zero,
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           fit: BoxFit.fill,
//           image: AssetImage('assets/drawer_background_image.jpg'),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Text(
//             'FootBall King App',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _createDrawerItem({final icon, final text, final onTap}) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(text),
//       onTap: onTap,
//     );
//   }
// }
