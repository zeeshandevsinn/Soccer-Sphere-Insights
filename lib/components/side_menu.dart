import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenuBar extends StatefulWidget {
  const SideMenuBar({super.key});

  @override
  State<SideMenuBar> createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.blue.shade700,
        ),
        drawer: const NavigationDrawer());
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Color(0xfa2d8dbd).withOpacity(.86),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(context),
              buildMenueItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );
  }

  Widget buildMenueItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.sportscourt),
            title: const Text("Leagues"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text("Live Match"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.news),
            title: const Text("News"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.hand_point_right_fill),
            title: const Text("Highlights"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sports_basketball),
            title: const Text("BasketBall"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
