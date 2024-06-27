import 'dart:convert';

import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:app4_6_8/new_road_map/controller/custom_hotMatches.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/match_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotMatchDetailsScreen extends StatefulWidget {
  final allMatches;
  const HotMatchDetailsScreen({super.key, required this.allMatches});

  @override
  State<HotMatchDetailsScreen> createState() => _HotMatchDetailsScreenState();
}

class _HotMatchDetailsScreenState extends State<HotMatchDetailsScreen> {
  List availableTeams = [];
  List visibleTeams = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMatches();
    searchController.addListener(() {
      filterTeams();
    });
  }

  fetchMatches() {
    if (widget.allMatches != null) {
      setState(() {
        availableTeams = widget.allMatches;
        visibleTeams = availableTeams;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Exception(["Here Data not Found"]);
    }
  }

  void filterTeams() {
    final query = searchController.text.toLowerCase();
    setState(() {
      visibleTeams = availableTeams.where((team) {
        final teamName = team['league']['name'].toLowerCase();
        return teamName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.blackColor,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: MyColors.white,
                  ),
                )
              ],
            ),
            Text(
              "HOT MATCHES DETAILS",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: MyColors.orangeColor),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: searchController,
                style: TextStyle(color: MyColors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    hintStyle: TextStyle(color: MyColors.white),
                    hintText: 'Search Hot Matches ...',
                    icon: Icon(Icons.search),
                    fillColor: MyColors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : visibleTeams.isEmpty
                      ? Center(child: Text('No teams available'))
                      : ListView.builder(
                          key: Key('teamListView'),
                          itemCount: visibleTeams.length,
                          itemBuilder: (context, index) {
                            final matches = visibleTeams[index];
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
                              AwayGoal: matches['goals']['home'],
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
