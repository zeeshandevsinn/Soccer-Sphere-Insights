import 'package:app4_6_8/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class SoccerNewsScreen extends StatefulWidget {
  @override
  _SoccerNewsScreenState createState() => _SoccerNewsScreenState();
}

class _SoccerNewsScreenState extends State<SoccerNewsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    const String apiUrl =
        'https://football-news-aggregator-live.p.rapidapi.com/news/fourfourtwo/bundesliga';
    const Map<String, String> headers = {
      'X-RapidAPI-Key': '64a0a0da7emsh85e2fd2975d435fp197eb0jsn2bb9bfebada6',
      'X-RapidAPI-Host': 'football-news-aggregator-live.p.rapidapi.com'
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          articles = data ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load articles: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load articles: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Soccer News")),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.1.png'), fit: BoxFit.fill)),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : error.isNotEmpty
                ? Center(
                    child: Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 18)))
                : ListView.separated(
                    itemCount: articles.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Color(0xfa003031), height: 1),
                    itemBuilder: (context, index) {
                      var article = articles[index];
                      return ArticleCard(
                        title: article['title'] ?? 'No Title',
                        url: article['url'] ?? '',
                        imageUrl: article['img'] ?? '',
                      );
                    },
                  ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  final String url;
  final String imageUrl;

  const ArticleCard({
    Key? key,
    required this.title,
    required this.url,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleWebView(url: url)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
              colors: [Color(0xfaffffff), Color(0xfabdc6cb)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xfa003031)),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleWebView(url: url)),
                    );
                  },
                  child: Text(
                    'Read more',
                    style: TextStyle(color: Color(0xfa003031)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleWebView extends StatelessWidget {
  final String url;

  const ArticleWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(textTitle: "Article Details")),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
