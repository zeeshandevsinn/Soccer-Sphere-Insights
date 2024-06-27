import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:app4_6_8/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SoccerHighlightsScreen extends StatefulWidget {
  @override
  _SoccerHighlightsScreenState createState() => _SoccerHighlightsScreenState();
}

class _SoccerHighlightsScreenState extends State<SoccerHighlightsScreen> {
  Future<List<dynamic>> fetchHighlights() async {
    try {
      final response = await http.get(
        Uri.parse('https://free-football-soccer-videos.p.rapidapi.com/'),
        headers: {
          'X-RapidAPI-Key':
              '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
          'X-RapidAPI-Host': 'free-football-soccer-videos.p.rapidapi.com'
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load highlights');
      }
    } catch (e) {
      throw Exception('Failed to make network request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        iconTheme: IconThemeData(color: MyColors.white),
        title: Text("Soccer Videos Highlights"),
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
                fetchHighlights();
              });
            },
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<dynamic>>(
            future: fetchHighlights(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.red, fontSize: 18)));
              }

              return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  var highlight = snapshot.data![index];
                  return HighlightCard(highlight: highlight);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class HighlightCard extends StatelessWidget {
  final dynamic highlight;

  const HighlightCard({Key? key, required this.highlight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HighlightDetailScreen(highlight: highlight)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: MyColors.grey),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xfa000000).withOpacity(.10),
                child: Text(highlight['competition']['name'][0],
                    style: TextStyle(
                        color: MyColors.white, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      highlight['title'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      highlight['competition']['name'],
                      style: TextStyle(fontSize: 14, color: MyColors.white),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: MyColors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class HighlightDetailScreen extends StatelessWidget {
  final dynamic highlight;

  HighlightDetailScreen({required this.highlight});

  @override
  Widget build(BuildContext context) {
    final color = MyColors.white;

    return Scaffold(
      backgroundColor: MyColors.blackColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyColors.white),
        title: Text(highlight['title']),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: MyColors.grey),
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: highlight['embed']),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              supportZoom: false,
            ),
          ),
        ),
      ),
    );
  }
}
