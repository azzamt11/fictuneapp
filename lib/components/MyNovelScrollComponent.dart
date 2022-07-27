import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'NovelDirectCard.dart';

class MyNovelScrollComponent extends StatefulWidget {
  final String token;
  const MyNovelScrollComponent({Key? key, required this.token}) : super(key: key);

  @override
  State<MyNovelScrollComponent> createState() => _MyNovelScrollComponentState();
}

class _MyNovelScrollComponentState extends State<MyNovelScrollComponent> {
  bool loadingState= true;
  bool isMyNovelExist=true;
  bool isNetworkError=false;
  int loadingCount=0;
  List<String> novelData= [];
  @override
  Widget build(BuildContext context) {
    print('step_001: building the widget, checking the states: loadingState= $loadingState, isMyNovelExist= $isMyNovelExist, isNetworkError= $isNetworkError');
    if (loadingState==true && loadingCount<2) {
      print('step_002: state condition type-1 is occurred, submitting to getMyNovelData');
      setState(() {loadingState=false;});
      getMyNovelsData();
    } else if (loadingCount>=2) {
      setState(() {loadingState=false; isMyNovelExist=false;});
    }
    return getMyNovelsList();
  }

  Widget getMyNovelsList() {
    print('step_009: getNovelsList in progress, submitting to novelWidgetList');
    var size= MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: novelWidgetList(),
      )
    );
  }

  List<Widget> novelWidgetList() {
    print('step_010: novelWidgetList in progress, checking state: loadingState= $loadingState, isMyNovelExist= $isMyNovelExist, isNetworkError= $isNetworkError');
    List<Widget> widgetList= [];
    var size= MediaQuery.of(context).size;
    if (loadingState && isMyNovelExist) {
      print('step_011: state type-1 is entered');
      for (int i=0; i<4; i++) {
        widgetList.add(Container(
            height: 160,
            width: size.width,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
            child: Row(
                children: [
                  Container(
                    height: 150,
                    width: 100,
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    child: Center(
                      child: Text('Loading...$loadingCount', style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 150,
                      width: size.width-146,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 35, width: 150, color: const Color.fromRGBO(245, 245, 245, 1)),
                            const SizedBox(height: 10),
                            Container(height: 100, width: max(size.width-146, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
                          ]
                      )
                  ),
                ]
            )
        ));
      }
    } else if (!loadingState && isMyNovelExist && novelData.isNotEmpty) {
      print('step_011: state type-2 is entered, the data is ready to be exploited');
      for (int i=0; i<max(novelData.length-1, 1); i++) {
        widgetList.add(Container(
            height: 160,
            width: size.width,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
            child: Row(
                children: [
                  SizedBox(
                    height: 150,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        //just do nothing for a while
                      },
                      child: NovelDirectCard(novelData: novelData[i]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 150,
                      width: size.width-146,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 35,
                                width: 150,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(novelData[i].split('<divider%83>')[1].split('<divider%69>')[0], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold)),
                                )
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              width: max(size.width-146, 150),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(novelData[i].split('<divider%83>')[1].split('<divider%69>')[1], style: TextStyle(fontSize: 17, color: AppTheme.themeColor), overflow:TextOverflow.ellipsis ),
                                ),
                            ),
                          ]
                      )
                  ),
                ]
            )
        ));
      }
    } else if (isMyNovelExist && isNetworkError) {
      print('step_011: state type-3 is entered, returning the appropriate output');
      widgetList.add(SizedBox(
          height: 200,
          width: size.width,
          child: Center(
            child: Text('Network Error: Check your connection!', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
          )
      ));
    } else if (!isMyNovelExist) {
      print('step_011: state type-4 is entered, returning the appropriate output');
      widgetList.add(SizedBox(
          height: 200,
          width: size.width,
          child: Center(
          child: Text('You have not created any novels yet.', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        )
      ));
    }

    return widgetList;
  }

  Future<void> getMyNovelsData() async{
    print('step_003: getMyNovelData in progress');
    List<String> myNovelData= [];
    print('step_004: fetching myNovelsDataString the data from local storage');
    String? myNovelsDataString= await NetworkHandler().getString('user', 'myNovelData');
    if (myNovelsDataString!=null&& myNovelsDataString!='zero' && myNovelsDataString!='error') {
      print('step_005: myNovelsDataString is successfully fetched, separating with the divider');
      List<String> myNovelsDataArray= myNovelsDataString.split('<divider%71>');
      for (int i=0; i<max(myNovelsDataArray.length-1, 1); i++) {
        print('step_006: iteration $i in progress, myNovelData has been updated');
        myNovelData.add(myNovelsDataArray[i]);
      }
    } else if (myNovelsDataString=='zero'){
      print('step_005: myNovelsDataString is zero, chance the state isMyNovelExist to false');
      myNovelData.add('zero');
      setState(() {
        isMyNovelExist=false;
      });
    } else if (myNovelsDataString==null) {
      print('step_005: myNovelsDataString is null, submitting to getUsetNovels');
      List<List<String>> myNovelsDataArray= await NetworkHandler().getUserNovels(widget.token); //['success', novelId, novelTitle, novelImage])
      if (myNovelsDataArray[0][0]=='success') {
        print('step_006: myNovelsDataArray is successfully fetched from network, starting the iteration');
        for (int i=0; i<myNovelsDataArray.length; i++) {
          print('step_007: iteration $i is in progress, joining with separator');
          myNovelData.add(myNovelsDataArray[i][1]+ '<divider%83>'+ myNovelsDataArray[i][2] +'<divider%83>' + myNovelsDataArray[i][3]);
        }
      } else if (myNovelsDataString=='error') {
        print('step_006: myNovelsDataArray is failed to load from network, returning error, changing the states');
        myNovelData.add('error');
        setState(() {
          isNetworkError= true;
          loadingState= false;
          loadingCount++;
        });
      }
    }
    setState(() {
      print('step_008: updating novel data');
      novelData= myNovelData;
    });
  }
}
