import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:app4_6_8/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BasketballTeamsPage extends StatefulWidget {
  @override
  _BasketballTeamsPageState createState() => _BasketballTeamsPageState();
}

class _BasketballTeamsPageState extends State<BasketballTeamsPage> {
  final String apiKey = '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6';
  final String baseUrl = 'https://api-basketball.p.rapidapi.com';
  final String seasonYear = '2023-2024';
  int nbaLeagueId = -1;

  List<dynamic> teamsList = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getNbaLeagueId();
  }

  Future<void> getNbaLeagueId() async {
    final response = await http.get(
      Uri.parse('$baseUrl/leagues'),
      headers: {
        'x-rapidapi-host': 'api-basketball.p.rapidapi.com',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final leagues = json.decode(response.body)['response'] as List;
      final nbaLeague = leagues.firstWhere(
        (league) => league['name'] == 'NBA',
        orElse: () => null,
      );

      if (nbaLeague != null) {
        setState(() {
          nbaLeagueId = nbaLeague['id'];
        });
        fetchTeams();
      } else {
        setState(() {
          isLoading = true;
        });
        throw Exception('NBA league not found');
      }
    } else {
      setState(() {
        isLoading = true;
      });
      throw Exception('Failed to load leagues');
    }
  }

  Future<void> fetchTeams() async {
    if (nbaLeagueId == -1) return;

    final response = await http.get(
      Uri.parse('$baseUrl/teams?league=$nbaLeagueId&season=$seasonYear'),
      headers: {
        'x-rapidapi-host': 'api-basketball.p.rapidapi.com',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        teamsList = json.decode(response.body)['response'];
      });
      setState(() {
        isLoading = true;
      });
    } else {
      throw Exception('Failed to load teams');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        iconTheme: IconThemeData(color: MyColors.white),
        title: Text("BasketBall Details"),
        centerTitle: true,
        titleTextStyle: TextStyle(color: MyColors.white),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: MyColors.white,
            ),
            onPressed: () {
              setState(() {
                getNbaLeagueId();
              });
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: MyColors.blackColor),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: teamsList.isEmpty
              ? Center(child: CircularProgressIndicator())
              // : teamsList.isEmpty
              //     ? Center(
              //         child: Text(
              //         "Sorry the data of basketball is Empty",
              //         textAlign: TextAlign.center,
              //         style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //             fontWeight: FontWeight.bold,
              //             fontStyle: FontStyle.italic,
              //             color: MyColors.white),
              //       ))
              : ListView.builder(
                  itemCount: teamsList.length,
                  itemBuilder: (context, index) {
                    return TeamCard(
                        team: teamsList[index],
                        nbaLeagueId: nbaLeagueId,
                        seasonYear: seasonYear);
                  },
                ),
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final dynamic team;
  final int nbaLeagueId;
  final String seasonYear;

  TeamCard(
      {required this.team,
      required this.nbaLeagueId,
      required this.seasonYear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: MyColors.grey),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: team['logo'] != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(team['logo']),
              )
            : CircleAvatar(
                child: Icon(
                  Icons.sports_basketball,
                  color: MyColors.white,
                ),
              ),
        title: Text(
          team['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: MyColors.white,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: MyColors.white,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamStatsPage(
                leagueId: nbaLeagueId,
                season: seasonYear,
                teamId: team['id'],
                teamName: team['name'],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TeamStatsPage extends StatefulWidget {
  final int leagueId;
  final String season;
  final int teamId;
  final String teamName;

  TeamStatsPage({
    required this.leagueId,
    required this.season,
    required this.teamId,
    required this.teamName,
  });

  @override
  _TeamStatsPageState createState() => _TeamStatsPageState();
}

class _TeamStatsPageState extends State<TeamStatsPage> {
  final String apiKey = '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6';
  final String baseUrl = 'https://api-basketball.p.rapidapi.com';

  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    fetchTeamStats();
  }

  Future<void> fetchTeamStats() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/statistics?league=${widget.leagueId}&season=${widget.season}&team=${widget.teamId}'),
      headers: {
        'x-rapidapi-host': 'api-basketball.p.rapidapi.com',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        stats = json.decode(response.body)['response'];
      });
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        iconTheme: IconThemeData(color: MyColors.white),
        title: Text('${widget.teamName} Stats'),
        centerTitle: true,
        titleTextStyle: TextStyle(color: MyColors.white),
      ),
      body: Container(
        decoration: BoxDecoration(color: MyColors.blackColor),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: stats.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(stats['team']['logo']),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Team: ${stats['team']['name']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Country: ${stats['country']['name']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: MyColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'League: ${stats['league']['name']} (${stats['league']['season']})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      StatsCard(
                        title:
                            'Games Played: ${stats['games']['played']['all']}',
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wins: ${stats['games']['wins']['all']['total']} (${stats['games']['wins']['all']['percentage']})',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Losses: ${stats['games']['loses']['all']['total']} (${stats['games']['loses']['all']['percentage']})',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      StatsCard(
                        title:
                            'Points For: ${stats['points']['for']['total']['all']}',
                        subtitle: Text(
                          'Average: ${stats['points']['for']['average']['all']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 8),
                      StatsCard(
                        title:
                            'Points Against: ${stats['points']['against']['total']['all']}',
                        subtitle: Text(
                          'Average: ${stats['points']['against']['average']['all']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final Widget subtitle;

  StatsCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: MyColors.grey,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: MyColors.white,
          ),
        ),
        subtitle: subtitle,
      ),
    );
  }
}
