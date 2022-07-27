import 'package:flutter/material.dart';

import '../components/FavoriteNovelScrollComponent.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../components/MyNovelScrollComponent.dart';

class MeSlide extends StatefulWidget {
  final List<String> responseList;
  const MeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<MeSlide> createState() => _MeSlideState();
}

class _MeSlideState extends State<MeSlide> {
  final List<Color> colorArray= [Colors.white, AppTheme.themeColor];
  int colorState= 0;
  int activeSubWidget= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              GestureDetector(
                  child: const Icon(Icons.more_vert),
                  onTap: () {
                    // a certain action will be added here.
                  }
              )
            ]
        ),
        body: getSuperBody(),
    );
  }

  Widget getSuperBody() {
    var size= MediaQuery.of(context).size;
    String token= widget.responseList[1];
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('<divider%54>')[0];
    String userUserName= userUserData.split('<divider%54>')[0];
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
              height: 220,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 41,
                    backgroundColor: AppTheme.themeColor,
                    child: CircleAvatar(
                      backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                      radius: 40,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(userUserName, style: TextStyle(fontSize: 20, color: AppTheme.themeColor))
                  ),
                  SizedBox(
                      height: 40,
                      width: size.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(userBillingData.split('<divider%54>')[1], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold))
                                )
                            ),
                            Container(
                              child: const Center(child: Text('Buy Coin', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold))),
                              height: 40,
                              width: 100,
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(150, 50, 50, 1),
                              )
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coin.jpg')))
                                  ),
                                  Text(coin, style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
                                ],
                              ),
                            ),
                          ]
                      )
                  ),
                  const SizedBox(height: 30),
                ],
              )
          ),
          SizedBox(
            height: size.height-400,
            width: size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeSubWidget=0;
                              });
                            },
                            child: Text('Liked novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeSubWidget=1;
                              });
                            },
                            child: Text('My novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                          ),

                        ],
                      )
                  ),
                  SizedBox(
                    width: size.width-36,
                    child: Row(
                      children: [
                        Container(
                          height: 5,
                          width: 0.5*(size.width-36),
                          color: colorArray[1-activeSubWidget],
                        ),
                        Container(
                          height: 5,
                          width: 0.5*(size.width-36),
                          color: colorArray[activeSubWidget],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: size.width-34,
                    color: const Color.fromRGBO(50, 0, 100, 1),
                    margin: const EdgeInsets.only(bottom: 15),
                  ),
                  SizedBox(
                    height: size.height-471,
                    width: size.width,
                    child: IndexedStack(
                      index: activeSubWidget,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FavoriteNovelScrollComponent(token: token),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: MyNovelScrollComponent(token: token),
                        ),

                      ]
                    )
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}