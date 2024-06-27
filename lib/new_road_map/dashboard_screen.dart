import 'dart:convert';

import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:app4_6_8/new_road_map/controller/custom_hotMatches.dart';
import 'package:app4_6_8/new_road_map/controller/custom_news_update.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/hot_match_details_screen.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/match_details.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/news_web.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/trending_newsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var trendingNews;
  bool isLoadnews = true;
  String _baseUrl = 'https://allscores.p.rapidapi.com/api/allscores/news';

  fetchTrendingNews() async {
    final url =
        Uri.parse('$_baseUrl?sport=1&timezone=America%2FChicago&langId=1');
    final headers = {
      'x-rapidapi-host': 'allscores.p.rapidapi.com',
      'x-rapidapi-key': '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      var data = jsonDecode(response.body);
      // ignore: unnecessary_null_comparison
      if (data != null) {
        setState(() {
          trendingNews = data['news'];
          isLoadnews = false;
        });
      }
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load trending news');
    }
  }

  bool isLoadLive = true;
  var hotMatches;
  fetchLiveFixtures() async {
    final url = Uri.parse(
        'https://api-football-v1.p.rapidapi.com/v3/fixtures?live=all');
    final headers = {
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
      'x-rapidapi-key': '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> fixtures = jsonResponse['response'];
      if (fixtures != null) {
        setState(() {
          hotMatches = fixtures;
          isLoadLive = false;
        });
      }
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load live fixtures');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLiveFixtures();
    fetchTrendingNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: AssetImage(
              'assets/new_app_icon.png',
            ),
            radius: 20,
          ),
          title: Text(
            'Hi',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          subtitle: Text(
            'Welcome!',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: MyColors.white,
            ),
            onPressed: () {
              setState(() {
                fetchLiveFixtures();
                fetchTrendingNews();
              });
            },
          )
        ],
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              // Hot Matches Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hot Matches',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      if (hotMatches != null) {
                        Navigator.push(
                            context,
                            CupertinoDialogRoute(
                                builder: (_) => HotMatchDetailsScreen(
                                    allMatches: hotMatches),
                                context: context));
                      }
                    },
                    child: Text(
                      'See more',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
              // Match List
              isLoadLive
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : SizedBox(
                      height: 200, // Set a fixed height for the ListView
                      child: ListView.builder(
                          itemCount: hotMatches.length,
                          itemBuilder: (context, index) {
                            var matches = hotMatches[index];
                            return CustomHotMatches(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (_) =>
                                            MatchDetailsPage(match: matches),
                                        context: context));
                              },
                              ChampionshipName: matches['league']['name'] ?? "",
                              Date: matches['fixture']['date'] ?? "",
                              hometeamLogo: matches['teams']['home']['logo'] ??
                                  'https://via.placeholder.com/20',
                              hometeamName:
                                  matches['teams']['home']['name'] ?? "",
                              AwayteamLogo: matches['teams']['away']['logo'] ??
                                  'https://via.placeholder.com/20',
                              AwayteamName:
                                  matches['teams']['away']['name'] ?? "",
                              champ_img: matches['league']['logo'] ?? "",
                              homeGoal: matches['goals']['home'],
                              AwayGoal: matches['goals']['away'],
                            );
                          }),
                    ),
              // News Update Section
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'News Update',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoDialogRoute(
                              builder: (_) => TrendingNewsUpdates(
                                  trendingNews: trendingNews),
                              context: context));
                    },
                    child: Text(
                      'See more',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // News List
              isLoadnews
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : SizedBox(
                      height: 250, // Set a fixed height for the ListView
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingNews.length,
                          itemBuilder: (context, index) {
                            var news = trendingNews[index];
                            return CustomNewsUpdate(
                              height: 150,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (_) =>
                                            NewsWeb(url: news['url']),
                                        context: context));
                              },
                              image: news['image'],
                              Title: news['title'],
                              Date: news['publishDate'],
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
