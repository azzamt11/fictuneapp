import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class DebugSlide extends StatefulWidget {
  final String token;
  const DebugSlide({Key? key, required this.token}) : super(key: key);

  @override
  State<DebugSlide> createState() => _DebugSlideState();
}

class _DebugSlideState extends State<DebugSlide> {
  List<Widget> dataList= [];
  bool loaded= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Slide: $loaded'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
              children: dataList,
          )
        ),
      ),
    );
  }

  Future<void> addDataToDebugSlide(String data) async{
    var size= MediaQuery.of(context).size;
    dataList.add(
        Container(
          width: size.width,
          padding: const EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width-20),
            child: Align(alignment: Alignment.topLeft, child: Text(data, style: TextStyle(fontSize: 15, color: AppTheme.themeColor))),
          ),
        )
    );
  }

  void addData(String data) {
    var size= MediaQuery.of(context).size;
    setState(() {
      dataList.add(
          Container(
            width: size.width,
            padding: const EdgeInsets.all(10),
            child: Container(
              constraints: BoxConstraints(maxWidth: size.width-20),
              child: Align(alignment: Alignment.topLeft, child: Text(data, style: TextStyle(fontSize: 15, color: AppTheme.themeColor))),
            ),
          )
      );
    });
  }
}
