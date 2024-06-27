import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app4_6_8/baske.dart';
import 'package:app4_6_8/footnews.dart';
import 'package:app4_6_8/leagueshow.dart';
import 'package:app4_6_8/newlivematch.dart';
import 'package:app4_6_8/vidoesfot.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Route _createRoute(destination, barName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right to left
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  double value = 0;
  bool isDrawer = false;

  void openDrawer() {
    setState(() {
      value = 1;
      isDrawer = true;
    });
  }

  void closeDrawer() {
    setState(() {
      value = 0;
      isDrawer = false;
    });
  }

  static List<Widget> _pages = <Widget>[
    LeagueSelectionPage(),
    LiveFootballScoresPage(),
    SoccerNewsScreen(),
    SoccerHighlightsScreen(),
    BasketballTeamsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background container with image
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Drawer overlay to detect taps outside
          if (isDrawer)
            GestureDetector(
              onTap: closeDrawer,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          // Drawer container
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                transform: Matrix4.identity(),
                // ..setEntry(3, 2, 0.001)
                // ..setEntry(0, 3, 200 * val)
                // ..rotateY((pi / 6) * val),
                child: Scaffold(
                  body: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(),
                        const Spacer(),
                        const SizedBox(height: 20),
                        if (!isDrawer) ...[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              'assets/Goalpost Stats-1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: GestureDetector(
                              onTap: openDrawer,
                              child: Container(
                                width: size.width * .80,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/fill_.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Get Started",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            color: Color(0xfa000000),
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        Spacer(),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Drawer content
          if (isDrawer)
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: size.width * .75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/drawer.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        DrawerHeader(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/Goalpost Stats.png',
                                fit: BoxFit.contain,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 24, top: 24, bottom: 24),
                            child: Wrap(
                              runSpacing: 16,
                              children: [
                                _buildListTile(Icons.sports_soccer, "Leagues",
                                    0, _controller),
                                _buildListTile(
                                    Icons.sports, "Live Match", 1, _controller),
                                _buildListTile(
                                    Icons.article, "News", 2, _controller),
                                _buildListTile(Icons.video_collection,
                                    "Highlights", 3, _controller),
                                _buildListTile(Icons.sports_basketball,
                                    "BasketBall", 4, _controller),
                                Container(
                                  width: size.width * .60,
                                  child: const Divider(
                                    color: Color(0xfaffffff),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(20),
                                  child: ListTile(
                                    onTap: closeDrawer,
                                    leading: const Icon(Icons.exit_to_app,
                                        color: Colors.white, size: 30),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Exit Drawer",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Color(0xfaffffff),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward,
                                        color: Colors.white, size: 30),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget leadingIcon(var iconName, controller) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xfaffffff)),
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            double scale = 1.0;
            return Transform.scale(
              scale: 0.8 + (controller.value * 0.2),
              child: Icon(
                iconName,
                color: Color(0xfaffffff),
                size: 30 * scale,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, int index, controller) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _pages[index]),
        );
        // Close the drawer when a tile is tapped
      },
      contentPadding: EdgeInsets.only(left: 30),
      leading: leadingIcon(icon, controller),
      title: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Color(0xfaffffff),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
