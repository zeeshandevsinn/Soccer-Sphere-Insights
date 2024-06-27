import 'package:flutter/material.dart';

class CustomHotMatches extends StatelessWidget {
  final String ChampionshipName,
      Date,
      hometeamLogo,
      hometeamName,
      AwayteamLogo,
      champ_img,
      AwayteamName;

  final onTap;
  final int homeGoal, AwayGoal;
  const CustomHotMatches(
      {super.key,
      required this.ChampionshipName,
      required this.Date,
      required this.hometeamLogo,
      required this.hometeamName,
      required this.AwayteamLogo,
      required this.AwayteamName,
      required this.champ_img,
      required this.homeGoal,
      required this.AwayGoal,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width * 0.90,
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade800,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(champ_img),
                backgroundColor: Colors.grey,
              ),
              title: Container(
                width: 60,
                child: Text(
                  ChampionshipName,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Container(
                width: 60,
                child: Text(
                  Date,
                  style: TextStyle(color: Colors.deepOrange),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  hometeamLogo,
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Container(
                  width: 60,
                  child: Text(
                    hometeamName,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepOrange),
                  child: Center(
                    child: Text(
                      '$homeGoal - $AwayGoal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Image.network(
                  AwayteamLogo,
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Container(
                  width: 60,
                  child: Text(
                    AwayteamName,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
