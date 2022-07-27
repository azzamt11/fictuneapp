import 'package:flutter/cupertino.dart';

import '../helper/AppFunctions.dart';

class NovelDirectCard extends StatefulWidget {
  final String novelData;
  const NovelDirectCard({Key? key, required this.novelData}) : super(key: key);

  @override
  State<NovelDirectCard> createState() => _NovelDirectCardState();
}

class _NovelDirectCardState extends State<NovelDirectCard> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String novelImage= widget.novelData.split('<divider%83>')[2];
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(image: DecorationImage(
        fit: BoxFit.cover,
        image: MemoryImage(AppFunctions().convertBase64Image(novelImage)))
      ),
    );
  }
}
