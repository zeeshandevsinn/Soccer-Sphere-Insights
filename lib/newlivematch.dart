import 'package:app4_6_8/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class LiveFootballScoresPage extends StatefulWidget {
  @override
  _LiveFootballScoresPageState createState() => _LiveFootballScoresPageState();
}

class _LiveFootballScoresPageState extends State<LiveFootballScoresPage> {
  List<dynamic> liveMatchData = [];
  bool isLoading = true;
  String fetchError = '';

  @override
  void initState() {
    super.initState();
    fetchLiveFootballMatches();
  }

  Future<void> fetchLiveFootballMatches() async {
    try {
      final response = await http.get(
        Uri.parse('https://livescore6.p.rapidapi.com/matches/v2/list-live'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'livescore6.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          liveMatchData = json.decode(response.body)['Stages'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          fetchError = 'Failed to load matches: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        fetchError = 'Failed to load matches: $e';
        isLoading = false;
      });
    }
  }

  Future<String> getTeamLogoUrl(String teamName) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/teams?name=$teamName'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['response'] != null && data['response'].isNotEmpty) {
          return data['response'][0]['team']['logo'] ?? '';
        }
      }
    } catch (e) {
      print('Failed to load team logo: $e');
    }
    return '';
  }

  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: 'Live Soccer Scores')),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : fetchError.isNotEmpty
                ? Center(
                    child: Text(fetchError,
                        style: TextStyle(color: Colors.red, fontSize: 18)))
                : liveMatchData.isEmpty
                    ? Center(
                        child: Text(
                            "Sorry, there are no live matches scheduled at the moment. Stay tuned for updates on upcoming events!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xfa003031),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))
                    : ListView.builder(
                        itemCount: liveMatchData.length,
                        itemBuilder: (context, index) {
                          var event = liveMatchData[index]['Events'];
                          if (event == null || event.isEmpty) {
                            return SizedBox.shrink();
                          }
                          var match = event[0];
                          return FootballMatchCard(
                            homeTeamName: match['T1'][0]['Nm'] ?? 'Unknown',
                            awayTeamName: match['T2'][0]['Nm'] ?? 'Unknown',
                            homeTeamScore: match['Tr1'].toString(),
                            awayTeamScore: match['Tr2'].toString(),
                            homeTeamLogo:
                                getTeamLogoUrl(match['T1'][0]['Nm'] ?? ''),
                            awayTeamLogo:
                                getTeamLogoUrl(match['T2'][0]['Nm'] ?? ''),
                            matchStartTime:
                                formatTimestamp(match['Esd']?.toString() ?? ''),
                            matchVenue: match['Ven']?['Nm'] ?? 'Unknown',
                          );
                        },
                      ),
      ),
    );
  }
}

class FootballMatchCard extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamScore;
  final String awayTeamScore;
  final Future<String> homeTeamLogo;
  final Future<String> awayTeamLogo;
  final String matchStartTime;
  final String matchVenue;

  const FootballMatchCard({
    Key? key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.matchStartTime,
    required this.matchVenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
            colors: [Color(0xfaffffff), Color(0xfabdc6cb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            FutureBuilder(
              future: Future.wait([homeTeamLogo, awayTeamLogo]),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TeamDetailsColumn(
                        teamName: homeTeamName,
                        teamLogoUrl: snapshot.data?[0] ?? '',
                        teamScore: homeTeamScore,
                        textColor: Color(0xfa003031),
                      ),
                    ),
                    Expanded(
                      child: MatchInfoColumn(
                        startTime: matchStartTime,
                        venue: matchVenue,
                      ),
                    ),
                    Expanded(
                      child: TeamDetailsColumn(
                        teamName: awayTeamName,
                        teamLogoUrl: snapshot.data?[1] ?? '',
                        teamScore: awayTeamScore,
                        textColor: Color(0xfa003031),
                        isHomeTeam: false,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              'Kick-off at $matchStartTime | Venue: $matchVenue',
              style: TextStyle(fontSize: 14, color: Color(0xfa003031)),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamDetailsColumn extends StatelessWidget {
  final String teamName;
  final String teamLogoUrl;
  final String teamScore;
  final Color textColor;
  final bool isHomeTeam;

  const TeamDetailsColumn({
    Key? key,
    required this.teamName,
    required this.teamLogoUrl,
    required this.teamScore,
    this.textColor = Colors.deepPurple,
    this.isHomeTeam = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(teamLogoUrl),
          onBackgroundImageError: (error, stackTrace) {
            print('Failed to load image: $error' +
                'image : $teamLogoUrl'); // Log the error
          },
          child: teamLogoUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    teamLogoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: $error'); // Log the error
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 50),
                            SizedBox(height: 10),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Icon(Icons.error,
                  color: Colors.red, size: 50), // Fallback icon if URL is empty
        ),
        SizedBox(height: 8),
        Text(teamName,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        Text(teamScore,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }
}

class MatchInfoColumn extends StatelessWidget {
  final String startTime;
  final String venue;

  const MatchInfoColumn({
    Key? key,
    required this.startTime,
    required this.venue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.access_time, color: Color(0xfa003031)),
        Text(startTime,
            style: TextStyle(fontSize: 12, color: Color(0xfa003031))),
        SizedBox(height: 8),
        Icon(Icons.place, color: Color(0xfa003031)),
        Text(venue, style: TextStyle(fontSize: 12, color: Color(0xfa003031))),
      ],
    );
  }
}
