import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import '../pages/NovelPage.dart';

class NovelCard extends StatefulWidget {
  final String genre;
  final String index;
  final String userId;
  final String token;
  final int custom;
  const NovelCard({Key? key, required this.genre, required this.index, required this.userId, required this.token, required this.custom}) : super(key: key);

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  bool loadingState= true;
  Widget activeWidget= Container(
      height: 150,
      width: 100,
      color: const Color.fromRGBO(245, 245, 245, 1),
      child: Center(child: Text('Loading...', style: TextStyle(fontSize: 15, color: AppTheme.themeColor)))
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  //scaffold
  @override
  Widget build(BuildContext context) {
    print('novel card in progress');
    if (loadingState==true) {getNovelData(); setState(() {loadingState= false;});}
    return activeWidget;
  }

  Future<void> getNovelData() async{
    String index=widget.index;
    String genre=widget.genre;
    String token=widget.token;
    if (widget.custom==0) {
      List<String> novelDataArray= await NetworkHandler().getLatestPostsByGenre(genre, index, token);
      final novelId= novelDataArray[1];
      final novelTitle= novelDataArray[2];
      final novelImage= novelDataArray[3];
      final novelRate= novelDataArray[4];
      final novelGenre= novelDataArray[5];
      final novelAuthorId= novelDataArray[6];
      String novelDataString= novelId+'<divider%83>'+novelTitle+'<divider%83>'+novelImage+ '<divider%83>'+ novelRate+ '<divider%83>'+ novelGenre + '<divider%83>'+ novelAuthorId;
      NetworkHandler().saveString('user', 'novelData$novelId', novelDataString);
      print('step_013: novel data string has been saved with key: novelData$novelId');
      setState(() {
        activeWidget= GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> NovelPage(token: token, novelId: novelId)));
          },
          child: Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(AppFunctions().convertBase64Image(novelImage)),
                  )
              )
          ),
        );
      });
    }

  }

  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= const Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }
}