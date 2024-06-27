import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchDetailsPage extends StatefulWidget {
  final match;
  const MatchDetailsPage({super.key, required this.match});

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? matchData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchMatchDetails();
  }

  fetchMatchDetails() async {
    if (widget.match != null) {
      setState(() {
        matchData = widget.match;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: MyColors.white),
        title: Text(
          'Welcome to News Details',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: MyColors.orangeColor,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Fixture'),
            Tab(text: 'Event Match'),
          ],
        ),
      ),
      body: matchData == null
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                FixtureTab(data: matchData!),
                EventMatchTab(data: matchData!),
              ],
            ),
    );
  }
}

class FixtureTab extends StatelessWidget {
  final Map<String, dynamic> data;

  FixtureTab({required this.data});

  @override
  Widget build(BuildContext context) {
    var awaywin = data['teams']['home']['winner'];
    var homewin = data['teams']['away']['winner'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.network(
                data['league']['logo'],
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Text('League: ${data['league']['name']}',
                  style: TextStyle(
                      color: MyColors.orangeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Date: ${data['fixture']['date']}",
            style: TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          Text(
            "Season: ${data['league']['season']}",
            style: TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          Text(
            "Round: ${data['league']['round']}",
            style: TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Match Team Details:",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: MyColors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: [
                Container(
                  child: Text(
                    data['teams']['home']['name'],
                    style: TextStyle(
                        color: MyColors.orangeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "VS",
                  style: TextStyle(
                      color: MyColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    data['teams']['away']['name'],
                    style: TextStyle(
                        color: MyColors.orangeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                data['teams']['home']['logo'],
                width: 60,
                height: 60,
              ),
              SizedBox(width: 10),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepOrange),
                child: Center(
                  child: Text(
                    '${data['goals']['home']} - ${data['goals']['away']}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.network(
                data['teams']['away']['logo'],
                width: 60,
                height: 60,
              ),
              SizedBox(width: 10),
            ],
          ),
          Text(
            "Results",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: MyColors.orangeColor),
          ),
          SizedBox(height: 10),
          homewin == true && awaywin == false
              ? Text(
                  "Winner - Loser",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: MyColors.white),
                )
              : homewin == false && awaywin == true
                  ? Text(
                      "Loser - Winner",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: MyColors.white),
                    )
                  : Text(
                      "Pending - Pending",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: MyColors.white),
                    ),
          Divider(
            color: MyColors.grey,
            thickness: 2,
          )
        ],
      ),
    );
  }
}

class EventMatchTab extends StatelessWidget {
  final Map<String, dynamic> data;

  EventMatchTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return data['events'].isEmpty
        ? Center(
            child: Text(
              "Here is Not Event Occur",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: MyColors.orangeColor),
            ),
          )
        : ListView.builder(
            itemCount: data['events'].length,
            itemBuilder: (context, index) {
              var event = data['events'][index];
              return Container(
                padding: EdgeInsets.all(20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      "Events of Match",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MyColors.orangeColor),
                    ),
                    Row(
                      children: [
                        Image.network(
                          event['team']['logo'],
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Team: ${event['team']['name']}',
                            style: TextStyle(
                                color: MyColors.orangeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Player: ${event['player']['name']}",
                        style: TextStyle(
                            color: MyColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Event Type: ${event['type']}",
                        style: TextStyle(
                            color: MyColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Details: ${event['detail']}",
                        style: TextStyle(
                            color: MyColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: MyColors.grey,
                      thickness: 2,
                    )
                  ],
                ),
              );
            },
          );
  }
}
