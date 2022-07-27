import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'NovelDirectCard.dart';

class FavoriteNovelScrollComponent extends StatefulWidget {
  final String token;
  const FavoriteNovelScrollComponent({Key? key, required this.token}) : super(key: key);

  @override
  State<FavoriteNovelScrollComponent> createState() => _FavoriteNovelScrollComponentState();
}

class _FavoriteNovelScrollComponentState extends State<FavoriteNovelScrollComponent> {
  bool loadingState= true;
  int loadingCount=0;
  bool isFavoriteNovelExist=true;
  bool isNetworkError= false;
  List<String> novelData= [];
  List<String> novelsList= [];
  @override
  Widget build(BuildContext context) {
    print('step_001: building the widget, checking the states: loadingState= $loadingState, isFavoriteNovelExist= $isFavoriteNovelExist, isNetworkError= $isNetworkError');
    if (loadingState==true && loadingCount<2) {
      print('step_002: state condition type-1 is occurred, submitting to getFavoriteNovelData');
      setState(() {loadingState=false;});
      getFavoriteNovelsData();
    } else if (loadingCount>=2) {
      print('step_002: state condition type-2 is occurred, submitting to getFavoriteNovelsList');
      setState(() {loadingState=false;});
    }
    return getFavoriteNovelsList();
  }

  Widget getFavoriteNovelsList() {
    print('step_012: getFavoriteNovelsList in progress, submitting to novelWidgetList');
    var size= MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: novelWidgetList(),
      )
    );
  }

  List<Widget> novelWidgetList() {
    print('step_013: NovelWidgetList in progress');
    List<Widget> widgetList= [];
    var size= MediaQuery.of(context).size;
    if (loadingState && isFavoriteNovelExist && !isNetworkError) {
      print('step_014: state type-1 is occurred');
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
                      child: Text('Loading...', style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
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
    } else if (!loadingState && isFavoriteNovelExist && !isNetworkError && novelData.isNotEmpty) {
      print('step_014: state type-2 is occurred');
      for (int i=0; i<novelData.length; i++) {
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
                                  child: Text(novelData[i].split('<divider%83>')[1].split('<divider%69>')[1], style: TextStyle(fontSize: 17, color: AppTheme.themeColor), overflow: TextOverflow.ellipsis),
                                )
                            ),
                          ]
                      )
                  ),
                ]
            )
        ));
      }
    } else if (isFavoriteNovelExist && isNetworkError) {
      print('step_014: state type-3 is occurred');
      widgetList.add(SizedBox(
          height: 200,
          width: size.width,
          child: Center(
            child: Text('Network Error: Check your connection!', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
          )
      ));
    } else if (!isFavoriteNovelExist) {
      print('step_014: state type-4 is occurred');
      widgetList.add(SizedBox(
          height: 200,
          width: size.width,
          child: Center(
            child: Text('You have not liked any novels yet.', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
          )
      ));
    }

    return widgetList;
  }

  Future<void> getFavoriteNovelsData() async{
    print('step_003: getFavoriteNovelData in progress');
    List<String> favoriteNovelData= [];
    print('step_004: fetching favoriteNovelsDataIndices the data from local storage');
    String? favoriteNovelsIndices= await NetworkHandler().getString('user', 'userLikedNovelsIndices');
    print('step_004b: favoriteNovelsDataIndices : $favoriteNovelsIndices');
    if (favoriteNovelsIndices==null) {
      print('step_005: favoriteNovelsIndices is failed to load from local storage, fetching from network');
      List<String> favoriteNovelsIndicesArray= await NetworkHandler().getUserLikedNovelIndices(widget.token);
      if(favoriteNovelsIndicesArray[0]=='success') {
        favoriteNovelsIndices= favoriteNovelsIndicesArray[1];
        print('step_006: favoriteNovelsDataIndices is successfully to load from network, favoriteNovelIndices: $favoriteNovelsIndices, separating with %');
        List<String> favoriteNovelsIndexList= favoriteNovelsIndices.split('%');
        for (int i=0; i<max(favoriteNovelsIndexList.length-1, 1); i++) {
          String ithNovelId= favoriteNovelsIndexList[i];
          print('step_007: iteration $i for id $ithNovelId is in progress');
          String? ithFavoriteNovelData= await NetworkHandler().getString('user', 'novelData$ithNovelId');
          print('step_008: favoriteNovels of id $ithNovelId is successfully loaded from local storage, checking the null-error-zero condition');
          if (ithFavoriteNovelData!=null && ithFavoriteNovelData!='error' && ithFavoriteNovelData!='zero') {
            print('step_009: the data passed null-error-zero condition, adding to favoriteNovelData');
            favoriteNovelData.add(ithFavoriteNovelData);
          } else {
            print('step_010: the data failed to pass null-error-zero condition, fetching to network');
            List<String> ithFavoriteNovelData= await NetworkHandler().getPostById(widget.token, ithNovelId);
            if (ithFavoriteNovelData[0]=='success') {
              print('step_011: the data successfully loaded from network, adding to favoriteNovelData and saving to local storage');
              String novelDataString= ithNovelId+ '<divider%83>'+ithFavoriteNovelData[1]+ '<divider%83>'+ ithFavoriteNovelData[2];
              favoriteNovelData.add(novelDataString);
              NetworkHandler().saveString('user', 'novelData$ithNovelId', novelDataString);
            }
          }
        }
      } else {
        print('step_006: favoriteNovelsDataIndices is failed to load from network, changing the states');
        setState(() {
          isNetworkError=true;
          loadingState= false;
        });
      }
    } else if (favoriteNovelsIndices!='null' && favoriteNovelsIndices!='error' && favoriteNovelsIndices!='zero') {
      print('step_005: favoriteNovelsIndices is successfully loaded from local storage, passing the null-error-zero condition, separating with %');
      List<String> favoriteNovelsIndexList= favoriteNovelsIndices.split('%');
      for (int i=0; i<max(favoriteNovelsIndexList.length-1, 1); i++) {
        String ithNovelId= favoriteNovelsIndexList[i];
        print('step_006: iteration $i for id $ithNovelId is in progress');
        String? ithFavoriteNovelData= await NetworkHandler().getString('user', 'novelData$ithNovelId');
        print('step_007: favoriteNovels of id $ithNovelId is successfully loaded from local storage, checking the null-error-zero condition');
        if (ithFavoriteNovelData!=null && ithFavoriteNovelData!='error' && ithFavoriteNovelData!='zero') {
          print('step_008: the data passed null-error-zero condition, adding to favoriteNovelData');
          favoriteNovelData.add(ithFavoriteNovelData);
        } else {
          print('step_009: the data failed to pass null-error-zero condition, fetching to network');
          List<String> ithFavoriteNovelData= await NetworkHandler().getPostById(widget.token, ithNovelId);
          if (ithFavoriteNovelData[0]=='success') {
            print('step_010: the data successfully loaded from network, adding to favoriteNovelData and saving to local storage');
            favoriteNovelData.add(ithNovelId+ '<divider%83>'+ithFavoriteNovelData[1]+ '<divider%83>'+ ithFavoriteNovelData[2]);
            String novelDataString= ithNovelId+ '<divider%83>'+ithFavoriteNovelData[1]+ '<divider%83>'+ ithFavoriteNovelData[2];
            favoriteNovelData.add(novelDataString);
            NetworkHandler().saveString('user', 'novelData$ithNovelId', novelDataString);
          }
        }
      }
    } else if (favoriteNovelsIndices=='null' || favoriteNovelsIndices=='' || favoriteNovelsIndices=='zero'){
      print('step_005: favoriteNovelsIndices is successfully loaded from local storage but returning zero, setting sFavoriteNovelExist to false');
      print('zero favorite novel data detected');
      setState(() {
        isFavoriteNovelExist=false;
      });
    } else if (favoriteNovelsIndices=='error') {
      print('step_005: favoriteNovelsIndices is successfully loaded from local storage but returning zero, setting sFavoriteNovelExist to false');
      favoriteNovelData.add('error');
      setState(() {
        isNetworkError=true;
        loadingState= false;
        loadingCount++;
      });
    }
    setState(() {
      print('step_008: updating novel data');
      novelData= favoriteNovelData;
    });
  }

}
