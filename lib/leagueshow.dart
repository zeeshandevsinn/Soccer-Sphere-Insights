import 'package:app4_6_8/utils/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeagueSelectionPage extends StatefulWidget {
  @override
  LeagueSelectionPageState createState() => LeagueSelectionPageState();
}

class LeagueSelectionPageState extends State<LeagueSelectionPage> {
  List availableLeagues = [];
  List visibleLeagues = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLeagues();
    searchController.addListener(() {
      filterLeagues();
    });
  }

  Future<void> fetchLeagues() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-football-v1.p.rapidapi.com/v3/leagues'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          availableLeagues = json.decode(response.body)['response'];
          visibleLeagues = availableLeagues;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void filterLeagues() {
    final query = searchController.text.toLowerCase();
    setState(() {
      visibleLeagues = availableLeagues.where((league) {
        final leagueName = league['league']['name'].toLowerCase();
        final countryName = league['country']['name'].toLowerCase();
        return leagueName.contains(query) || countryName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Soccer League")),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  hintText: 'Search Leagues ...',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleLarge!
            //         .copyWith(fontStyle: FontStyle.italic),
            //     controller: searchController,
            //     keyboardType: TextInputType.text,
            //     decoration: InputDecoration(
            //       labelText: 'Search Leagues',
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //           borderSide: BorderSide(
            //               color: Color(0xfaffffff),
            //               width: 3,
            //               strokeAlign: BorderSide.strokeAlignOutside)),
            //       focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //           borderSide: BorderSide(
            //               color: Color(0xfaffffff),
            //               width: 3,
            //               strokeAlign: BorderSide.strokeAlignOutside)),
            //       prefixIcon: Icon(CupertinoIcons.search),
            //     ),
            //   ),
            // ),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                      ? Center(child: Text('Failed to load leagues'))
                      : visibleLeagues.isEmpty
                          ? Center(child: Text('No leagues available'))
                          : ListView.builder(
                              key: Key('leagueListView'),
                              itemCount: visibleLeagues.length,
                              itemBuilder: (context, index) {
                                final league = visibleLeagues[index];
                                final leagueName = league['league']['name'] ??
                                    'Unknown League';
                                final countryName = league['country']['name'] ??
                                    'Unknown Country';
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xfaffffff),
                                          Color(0xfabdc6cb)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: ListTile(
                                    key: Key('league_$index'),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        league['league']['logo'] ??
                                            'https://via.placeholder.com/50',
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(
                                      leagueName,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfa003031)),
                                    ),
                                    subtitle: Text(
                                      countryName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfa003031)),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 22,
                                        color: Color(0xfa003031)),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TeamSelectionPage(
                                                  leagueId: league['league']
                                                      ['id']),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamSelectionPage extends StatefulWidget {
  final int leagueId;

  TeamSelectionPage({required this.leagueId});

  @override
  TeamSelectionPageState createState() => TeamSelectionPageState();
}

class TeamSelectionPageState extends State<TeamSelectionPage> {
  List availableTeams = [];
  List visibleTeams = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTeams();
    searchController.addListener(() {
      filterTeams();
    });
  }

  Future<void> fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/teams?league=${widget.leagueId}&season=2023'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          availableTeams = json.decode(response.body)['response'];
          visibleTeams = availableTeams;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void filterTeams() {
    final query = searchController.text.toLowerCase();
    setState(() {
      visibleTeams = availableTeams.where((team) {
        final teamName = team['team']['name'].toLowerCase();
        return teamName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Select Soccer Team")),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  hintText: 'Search Teams ...',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleLarge!
            //         .copyWith(fontStyle: FontStyle.italic),
            //     controller: searchController,
            //     keyboardType: TextInputType.text,
            //     decoration: InputDecoration(
            //       labelText: 'Search Team',
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //           borderSide: BorderSide(
            //               color: Color(0xfaffffff),
            //               width: 3,
            //               strokeAlign: BorderSide.strokeAlignOutside)),
            //       focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //           borderSide: BorderSide(
            //               color: Color(0xfaffffff),
            //               width: 3,
            //               strokeAlign: BorderSide.strokeAlignOutside)),
            //       prefixIcon: Icon(CupertinoIcons.search),
            //     ),
            //   ),
            // ),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                      ? Center(child: Text('Failed to load teams'))
                      : visibleTeams.isEmpty
                          ? Center(child: Text('No teams available'))
                          : ListView.builder(
                              key: Key('teamListView'),
                              itemCount: visibleTeams.length,
                              itemBuilder: (context, index) {
                                final team = visibleTeams[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xfaffffff),
                                          Color(0xfabdc6cb)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: ListTile(
                                    key: Key('team_$index'),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(team['team']
                                              ['logo'] ??
                                          'https://via.placeholder.com/50'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(
                                      team['team']['name'] ?? 'Unknown Team',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfa003031)),
                                    ),
                                    subtitle: Text(
                                      team['venue']['name'] ?? 'Unknown Venue',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfa003031)),
                                    ),
                                    trailing: Icon(Icons.arrow_forward,
                                        color: Color(0xfa003031)),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SeasonSelectionScreen(
                                            leagueId: widget.leagueId,
                                            teamId: team['team']['id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeasonSelectionScreen extends StatefulWidget {
  final int leagueId;
  final int teamId;

  SeasonSelectionScreen({required this.leagueId, required this.teamId});

  @override
  _SeasonSelectionScreenState createState() => _SeasonSelectionScreenState();
}

class _SeasonSelectionScreenState extends State<SeasonSelectionScreen> {
  List availableSeasons = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchSeasons();
  }

  Future<void> _fetchSeasons() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-football-v1.p.rapidapi.com/v3/leagues/seasons'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          availableSeasons = json.decode(response.body)['response'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Select Soccer Season")),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Failed to load seasons'))
                : availableSeasons.isEmpty
                    ? Center(child: Text('No seasons available'))
                    : ListView.builder(
                        key: Key('seasonListView'),
                        itemCount: availableSeasons.length,
                        itemBuilder: (context, index) {
                          final season = availableSeasons[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xfaffffff),
                                    Color(0xfabdc6cb)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                            child: ListTile(
                              key: Key('season_$index'),
                              title: Text(
                                'Season $season',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xfa003031)),
                              ),
                              trailing: Icon(Icons.arrow_forward,
                                  color: Color(0xfa003031)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamStatsScreen(
                                      leagueId: widget.leagueId,
                                      teamId: widget.teamId,
                                      season: season,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

class TeamStatsScreen extends StatefulWidget {
  final int leagueId;
  final int teamId;
  final int season;

  TeamStatsScreen(
      {required this.leagueId, required this.teamId, required this.season});

  @override
  _TeamStatsScreenState createState() => _TeamStatsScreenState();
}

class _TeamStatsScreenState extends State<TeamStatsScreen> {
  Map teamStatistics = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTeamStatistics();
  }

  Future<void> _fetchTeamStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/teams/statistics?league=${widget.leagueId}&team=${widget.teamId}&season=${widget.season}'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          teamStatistics = json.decode(response.body)['response'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Widget _buildStatisticCard(String title, String value, {String? logoUrl}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
            colors: [Color(0xfaffffff), Color(0xfabdc6cb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logoUrl != null
                ? Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(logoUrl),
                      backgroundColor: Colors.transparent,
                      radius: 30,
                    ),
                  )
                : Container(),
            // SizedBox(height: 10),
            Text(title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: Color(0xfa003031))),
            // SizedBox(height: 5),
            Text(
              value,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold, color: Color(0xfa003031)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Team Statistics")),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Failed to load team statistics'))
                : teamStatistics.isEmpty
                    ? Center(child: Text('No statistics available'))
                    : Padding(
                        padding: EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: 15, // Total number of statistic cards
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return _buildStatisticCard(
                                  'League:',
                                  teamStatistics['league']['name'] ??
                                      'Unknown League',
                                  logoUrl: teamStatistics['league']['logo'],
                                );
                              case 1:
                                return _buildStatisticCard(
                                  'Team:',
                                  teamStatistics['team']['name'] ??
                                      'Unknown Team',
                                  logoUrl: teamStatistics['team']['logo'],
                                );
                              case 2:
                                return _buildStatisticCard(
                                  'Season:',
                                  widget.season.toString(),
                                );
                              case 3:
                                return _buildStatisticCard(
                                  'Matches Played:',
                                  teamStatistics['fixtures']['played']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 4:
                                return _buildStatisticCard(
                                  'Wins:',
                                  teamStatistics['fixtures']['wins']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 5:
                                return _buildStatisticCard(
                                  'Draws:',
                                  teamStatistics['fixtures']['draws']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 6:
                                return _buildStatisticCard(
                                  'Losses:',
                                  teamStatistics['fixtures']['loses']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 7:
                                return _buildStatisticCard(
                                  'Goals For:',
                                  teamStatistics['goals']['for']['total']
                                              ['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 8:
                                return _buildStatisticCard(
                                  'Goals Against:',
                                  teamStatistics['goals']['against']['total']
                                              ['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 9:
                                return _buildStatisticCard(
                                  'Clean Sheets:',
                                  teamStatistics['clean_sheet']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 10:
                                return _buildStatisticCard(
                                  'Failed to Score:',
                                  teamStatistics['failed_to_score']['total']
                                          .toString() ??
                                      'N/A',
                                );
                              case 11:
                                return _buildStatisticCard(
                                  'Biggest Win (Home):',
                                  teamStatistics['biggest']['wins']['home']
                                          .toString() ??
                                      'N/A',
                                );
                              case 12:
                                return _buildStatisticCard(
                                  'Biggest Win (Away):',
                                  teamStatistics['biggest']['wins']['away']
                                          .toString() ??
                                      'N/A',
                                );
                              case 13:
                                return _buildStatisticCard(
                                  'Biggest Loss (Home):',
                                  teamStatistics['biggest']['loses']['home']
                                          .toString() ??
                                      'N/A',
                                );
                              case 14:
                                return _buildStatisticCard(
                                  'Biggest Loss (Away):',
                                  teamStatistics['biggest']['loses']['away']
                                          .toString() ??
                                      'N/A',
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
      ),
    );
  }
}
