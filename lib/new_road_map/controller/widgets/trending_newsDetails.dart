import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:app4_6_8/new_road_map/controller/custom_news_update.dart';
import 'package:app4_6_8/new_road_map/controller/widgets/news_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingNewsUpdates extends StatefulWidget {
  final trendingNews;
  const TrendingNewsUpdates({super.key, required this.trendingNews});

  @override
  State<TrendingNewsUpdates> createState() => _TrendingNewsUpdatesState();
}

class _TrendingNewsUpdatesState extends State<TrendingNewsUpdates> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNews();
  }

  bool isLoading = true;

  fetchNews() {
    if (widget.trendingNews != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Exception(["Here Some thing Wrong"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              "Trending News Updates",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: MyColors.orangeColor),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : widget.trendingNews.isEmpty
                      ? Center(child: Text('No teams available'))
                      : ListView.builder(
                          key: Key('teamListView'),
                          itemCount: widget.trendingNews.length,
                          itemBuilder: (context, index) {
                            var news = widget.trendingNews[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0, top: 10),
                              child: CustomNewsUpdate(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoDialogRoute(
                                          builder: (_) =>
                                              NewsWeb(url: news['url']),
                                          context: context));
                                },
                                height: 230,
                                width: size.width,
                                image: news['image'],
                                Title: news['title'],
                                Date: news['publishDate'],
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }
}
