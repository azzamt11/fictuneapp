import 'package:flutter/material.dart';

import '../components/MainPageView.dart';
import '../components/NovelCard.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../pages/NovelPage.dart';

//home page constructor
class HomeSlide extends StatefulWidget {
  final List<String> responseList;
  const HomeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

//home page state
class _HomeSlideState extends State<HomeSlide> {
  //build
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('<divider%54>')[0];
    String userUserName= userUserData.split('<divider%54>')[0];
    var themeColor= AppTheme.themeColor;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.white,
          actions: [
            Container(
                height: 70,
                width: size.width*0.42,
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        userUserName,
                        style: TextStyle(
                            color: AppTheme.themeColor,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis)
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.only(right: 16),
                height: 70,
                child: Center(
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: AppTheme.themeColor,
                      child: CircleAvatar(
                          backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                          radius: 25, 
                      ),
                    )
                )
            ),
          ],
          leadingWidth: size.width*0.46,
          leading: SizedBox(
            height: 70,
            child: Row(
              children: [
                const SizedBox(
                  height: 70,
                  width: 55,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(backgroundImage: AssetImage('assets/images/coin.jpg'), radius: 20,)
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(coin, style: TextStyle(fontSize: 20, color: themeColor)))
                ),
              ]
            )
          ),
          expandedHeight: size.height*0.46,
          flexibleSpace: const FlexibleSpaceBar(
            background: MainPageView(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                height: 1320,
                color: Colors.white,
                child: Column(
                  children: [
                    novelCard('New Arrivals', 0),
                    novelCard('Romance', 1),
                    novelCard('Family', 2),
                    novelCard('Fantasy', 3),
                    novelCard('Science-Fiction', 4),
                    novelCard('Psychological', 5),
                  ]
                )
              )
            )
          )
        ),
      ]
    );
  }

  //widgets and functions:
  //novel card
  Widget buildCard(List<String> responseList, int genre, int index) {
    String token= responseList[1];
    String userId= responseList[3];
    List<String> novelData= [token, userId, '$genre', '$index'];
    return NovelCard(userId: userId, genre: '$genre', index: '$index', token: token, custom: 0);
  }

  //novel card widget
  Widget novelCard(String genreName, int genre) {
    var size= MediaQuery.of(context).size;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: genreText(genreName),
          ),
          Container(
            height: 1,
            width: size.width*0.8,
            color: const Color.fromRGBO(50, 0, 100, 1),
            margin: const EdgeInsets.only(left: 15, bottom: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              height: 150,
              width: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: novelCardWidget(genre),
                ),
              ),
            ),
          )
        ]
    );
  }

  List<Widget> novelCardWidget(int genre) {
    List<Widget> widgetList= [];
    for (int i=0; i<10; i++) {
      widgetList.add(buildCard(widget.responseList, genre, i));
      widgetList.add(const SizedBox(width: 10));
    }
    return widgetList;
  }

  //genre text
  Text genreText(String string) {
    return Text(
        string,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.themeColor,),
    );
  }
}

