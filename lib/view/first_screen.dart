import 'dart:convert';

import 'package:app4_6_8/baske.dart';
import 'package:app4_6_8/footnews.dart';
import 'package:app4_6_8/leagueshow.dart';
import 'package:app4_6_8/newlivematch.dart';
import 'package:app4_6_8/vidoesfot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<dynamic> liveFixtures = [];
  List<dynamic> filteredFixtures = [];
  TextEditingController searchController = TextEditingController();
  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    fetchLiveFixtures();
    searchController.addListener(_filterFixtures);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterFixtures);
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchLiveFixtures() async {
    final url = Uri.parse(
        'https://api-football-v1.p.rapidapi.com/v3/fixtures?live=all');
    final headers = {
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
      'x-rapidapi-key': '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          liveFixtures = data['response'];
          filteredFixtures = liveFixtures;
        });
      } else {
        print('Failed to fetch live fixtures');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterFixtures() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFixtures = liveFixtures.where((fixture) {
        final homeTeam = fixture['teams']['home']['name'].toLowerCase();
        final awayTeam = fixture['teams']['away']['name'].toLowerCase();
        return homeTeam.contains(query) || awayTeam.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50), // For status bar padding
                // Logo and Welcome Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Goalpost Stats-1.png',
                          height: 60,
                          width: size.width * .80,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome to Soccer League',
                          style: TextStyle(
                            color: Color(0xfa003031),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // User Profile Icon or Sign In Button
                  ],
                ),
                SizedBox(height: 20),
                // TextFormField(
                //   controller: searchController,
                //   decoration: InputDecoration(
                //     hintText: 'Search teams, players...',
                //     border: InputBorder.none,
                //     icon: Icon(Icons.search),
                //   ),
                // ),
                TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    hintText: 'Search teams, players...',
                    icon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 15),
                // Featured Matches Carousel
                Expanded(
                  child: filteredFixtures.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: filteredFixtures.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final fixture = filteredFixtures[index];
                            String dateTimeStr = fixture['fixture']['date'];
                            String formattedDateTime =
                                formatDateTime(dateTimeStr);
                            String leagureImg = fixture['league']['logo'];
                            String leagueName = fixture['league']['name'];
                            String HomeImg = fixture['teams']['home']['logo'];
                            String AwayImg = fixture['teams']['away']['logo'];
                            return _buildMatchCard(
                                leagureImg,
                                leagueName,
                                HomeImg,
                                AwayImg,
                                '${fixture['teams']['home']['name']} vs ${fixture['teams']['away']['name']}',
                                '${fixture['goals']['home']} - ${fixture['goals']['away']}',
                                formattedDateTime);
                          },
                        ),
                ),
                // child: ListView(
                //   scrollDirection: Axis.horizontal,
                //   children: [
                //     _buildMatchCard('Team C vs Team D', 'Tomorrow, 5:00 PM'),
                //   ],
                // ),
                // )
                SizedBox(height: 30),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavButton(Icons.sports_soccer, "Leagues", 0),
                    _buildNavButton(Icons.live_tv, "Live Match", 1),
                    _buildNavButton(Icons.article, "News", 2),
                    _buildNavButton(Icons.leaderboard, "Highlights", 3),
                    _buildNavButton(Icons.sports_basketball, "BasketBall", 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => _pages[index],
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

  List<Widget> _pages = <Widget>[
    LeagueSelectionPage(),
    LiveFootballScoresPage(),
    SoccerNewsScreen(),
    SoccerHighlightsScreen(),
    BasketballTeamsPage(),
  ];
  Widget _buildMatchCard(
      String champion_img,
      String CHAMPIONSHIP_NAME,
      String HomeImg,
      String AwayImg,
      String matchInfo,
      String score,
      String time) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(20),
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
            colors: [Color(0xfaffffff), Color(0xfabdc6cb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Column(
        children: [
          Image.network(
            champion_img,
            height: 100,
            width: 100,
          ),
          Text(
            CHAMPIONSHIP_NAME,
            style: TextStyle(
              color: Color(0xfa003031),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.network(
                HomeImg,
                height: 50,
                width: 50,
              ),
              Text(
                score,
                style: TextStyle(
                  color: Color(0xfa003031),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.network(
                AwayImg,
                height: 50,
                width: 50,
              ),
            ],
          ),
          Text(
            matchInfo,
            style: TextStyle(
              color: Color(0xfa003031),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            time,
            style: TextStyle(
              color: Color(0xfa003031),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, _createRoute(index));
      },
      child: Column(
        children: [
          Icon(icon, color: Color(0xfa003031), size: 30),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Color(0xfa003031),
            ),
          ),
        ],
      ),
    );
  }
}
