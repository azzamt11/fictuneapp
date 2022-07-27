import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class NovelDataCard extends StatefulWidget {
  final int custom;
  final String token;
  final String index;
  const NovelDataCard({Key? key, required this.custom, required this.index, required this.token}) : super(key: key);

  @override
  State<NovelDataCard> createState() => _NovelDataCardState();
}

class _NovelDataCardState extends State<NovelDataCard> {
  Widget activeWidget1= Text('Loading...', style: TextStyle(fontSize: 20, color: AppTheme.themeColor));
  Widget activeWidget2= Text('Loading...', style: TextStyle(fontSize: 17, color: AppTheme.themeColor));
  bool loadingState= true;

  @override
  Widget build(BuildContext context) {
    if (loadingState==true) {setNovelData(); setState(() {loadingState=false;});}
    var size= MediaQuery.of(context).size;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35, width: 150, child: Align(child: activeWidget1, alignment: Alignment.topLeft)),
          const SizedBox(height: 10),
          SizedBox(height: 100, width: max(size.width-146, 150), child: Align(child: activeWidget2, alignment: Alignment.topLeft)),
        ]
    );
  }

  Future<void> setNovelData() async{
    if (widget.custom==1) {
      String index=widget.index;
      print('novel data card custom on 1 in progress: on index: $index');
      List<String> novelData= await NetworkHandler().getPostById(widget.token, index);
      final novelDataString= novelData[1];
      final novelDataArray= novelDataString.split('<divider%69>');
      NetworkHandler().saveString('user', 'liked_novels_data_$index', novelData[1]);
      setState(() {
        activeWidget1= Text(novelDataArray[0], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold));
        activeWidget2= Text(novelDataArray[0], style: TextStyle(fontSize: 17, color: AppTheme.themeColor));
      });
    } else {
      String index=widget.index;
      print('novel data card custom on 2 in progress: on index: $index');
      String? novelDataString= await NetworkHandler().getString('user', 'liked_novels_data_$index');
      if (novelDataString!=null) {
        final novelDataArray= novelDataString.split('%');
        setState(() {
          activeWidget1= Text(novelDataArray[0], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold));
          activeWidget2= Text(novelDataArray[1], style: TextStyle(fontSize: 17, color: AppTheme.themeColor));
        });
      } else {
        final novelDataArray= ['novel $index', 'description'];
        setState(() {
          activeWidget1= Text(novelDataArray[0], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold));
          activeWidget2= Text(novelDataArray[1], style: TextStyle(fontSize: 17, color: AppTheme.themeColor));
        });
      }
    }
  }
}
