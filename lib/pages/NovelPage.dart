import 'package:fictune_frontend/files/RawImageFiles.dart';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class NovelPage extends StatefulWidget {
  final String token;
  final String novelId;
  const NovelPage({Key? key, required this.novelId, required this.token}) : super(key: key);

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  String author= 'Loading...';
  String rate= 'Loading...';
  List<List<String>> commentData= [];
  List<List<String>> commentatorDataList= [[]];
  String dataOnDebug= '';
  bool fixedLoading=true;
  bool loading=true;
  bool authorLoading=true;
  bool novelDataHasBeenLoadedFromNetwork= false;
  bool commentLoading= true;
  bool isThereAnyComment= true;
  bool errorOnLoadingCommentData= false;
  bool errorOnLoadingCommentatorData= false;
  List<String> novelData= ['0', 'Loading...<divider%69>Loading...', RawImageFiles().noData(), 'Loading...', 'Loading...'];

  @override
  Widget build(BuildContext context) {
    print('step_001 (NovelPage): build in progress, submitting to getNovelData');
    if (loading) {getNovelData(); loading=false;}
    if (commentLoading) {getCommentData(widget.novelId); setState(() {commentLoading=false;});}
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
          centerTitle: true,
          title: Text(novelData[1].split('<divider%69>')[0], style: const TextStyle(fontSize: 18, color: Colors.white)),
          elevation: 0,

        ),
      ),
      body: getBody(loading),
    );
  }

  Widget getBody(loading) {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      height: size.height- 70,
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: size.width,
            child: Row(
              children:[
                SizedBox(
                  height: 200,
                  width: 0.33*size.width,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: getNovelMainContainer(loading),
                  ),
                ),
                Container(
                  height: 200,
                  width: 0.67*size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNovelTitleContainer(loading, 0, 20, 'Title', 45, 150, true),
                        const SizedBox(height: 18),
                        getNovelAuthorContainer(fixedLoading, 18, 'Author', 28, 0.67*size.width-40),
                        const SizedBox(height: 2),
                        getNovelRatingContainer(loading, 27, 0.67*size.width-40),
                        const SizedBox(height: 12),
                        Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.themeColor),
                          child: const Center(
                            child: Text('Read Novel', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          )
                        ), //button
                      ]
                  ),
                ),
              ]
            )
          ),
          SizedBox(
            height: 15,
            child: Center(
              child: Container(
                height: 1,
                width: size.width- 40,
                color: AppTheme.themeColor,
              ),
            ),
          ),
          Container(
            height: size.height-348,
            width: size.width,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                SizedBox(
                  height: size.height-400,
                  width: size.width-40,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: size.width-40,
                      child: Column(
                        children: [
                          getNovelTitleContainer(loading, 1, 20, 'Synopsys', 45, 150, true),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.themeColor)),
                            width: size.width-40,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 35,
                                  width: 120,
                                  child: Text('Comments', style: TextStyle(fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1))),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: size.width-70,
                                  child: Column(
                                    children: getCommentList(size.width-70, commentData),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ]
                      ),
                    )
                  )
                )

              ]
            )
          ),
        ]
      )
    );
  }

  Future<void> getNovelData() async{
    print('step_002 (NovelPage): getNovelData in progress.');
    String novelId= widget.novelId;
    if (novelId!='0') {
      print('step_003 (NovelPage): get novel data in progress on novelId: $novelId');
      String? novelDataString= await NetworkHandler().getString('user', 'novelData$novelId');
      print('step_004 (NovelPage): get novel data has loaded the data from network, getting novelDataString');
      print(novelDataString);
      if (novelDataString!=null) {
        List<String> novelDataArray= novelDataString.split('<divider%83>');
        print('step_004b (NovelPage): separating novelDataString, submitting to novelData, submitting data to debugBox');
        String userId= novelDataArray[5];
        print('step_005 (NovelPage): submitting userId : $userId into get author data. executing get author data');
        getAuthorData(userId);
        setState(() {
          novelData= novelDataArray;
          loading=false;
          dataOnDebug='novelData= '+ novelData.toString()+ 'novelDataArray[4]='+ novelDataArray[4].toString();
        });
      }
    }
  }

  Widget getNovelMainContainer(bool loading) {
    if (loading) {
      return Container(
        height: 180,
        width: 120,
        child: Center(
          child: Text('Loading...', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        ),
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else {

      return Container(
        height: 180,
        width: 120,
        decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(AppFunctions().convertBase64Image(novelData[2])))),
      );
    }
  }

  Widget getNovelTitleContainer(bool titleLoading, int index, double fontSize, String text, double height, double width, bool bold) {
    if (titleLoading) {
      return Container(
        height: height,
        width: width,
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('$text: '+ novelData[1].split('<divider%69>')[index], style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: bold? FontWeight.bold : FontWeight.normal)),
        ),
      );
    }
  }

  Widget getNovelRatingContainer(bool titleLoading, double height, double width) {
    Widget starContainer;
    if (loading) {
      starContainer= Container(
        height: height,
        width: width,
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else if (novelData[3]=='0') {
      starContainer= SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [Text('Rating: Unrated', style: TextStyle(fontSize: 18, color: AppTheme.themeColor))],
          ),
        ),
      );
    } else {
      double rating=0;
      List<String> ratingDataArray= novelData[3].split('&');
      for (int i=0; i<ratingDataArray.length; i++) {
        List<String> ithRatingDataArray= ratingDataArray[i].split('%');
        if (ithRatingDataArray.length>1) {
          rating= rating+ int.parse(ithRatingDataArray[1]);
        }
      }
      rating= rating/(ratingDataArray.length);
      starContainer= SizedBox(
        height: height,
        width: width,
        child: Row(
          children: [
            SizedBox(
              height: height,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [Text('Rating: ', style: TextStyle(fontSize: 18, color: AppTheme.themeColor))],
                ),
              ),
            ),
            SizedBox(
              height: height,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: getStar(rating.ceil()),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: height,
      width: width,
      child: starContainer
      );
  }

  Widget getNovelAuthorContainer(bool loading, double fontSize, String text, double height, double width) {
    if (authorLoading) {
      return SizedBox(
        height: height,
        width: width,
          child: Align(
          alignment: Alignment.topLeft,
          child:Text('Author: Loading...', style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: FontWeight.normal)),
          )
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child:Text('Author: '+ author, style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: FontWeight.normal)),
        ),
      );
    }
  }

  List<Widget> getStar(int rating) {
    List<Widget> stars= [];
    for (int i=0; i<rating; i++) {
      stars.add(const Icon(Icons.star, size: 20, color: Colors.amber));
    }
    return stars;
  }

  Future<void> getAuthorData(String userId) async{
    print('step_006 (NovelPage): getAuthorData in progress');
    String? authorName= await NetworkHandler().getString('user', 'authorName$userId');
    if (authorName!=null && authorName!='error') {
      setState(() {
        AppFunctions().convertToTitleCase(authorName);
        authorLoading=false;
      });
    } else {
      print('step_007 (NovelPage): author data failed to load from local storage, get author data from network in progress on userId: $userId');
      if (userId!='error') {
        List<String> authorData= await NetworkHandler().getUser(widget.token, userId);
        String authorDataString= authorData.join('<divider%61>');
        NetworkHandler().saveString('user', 'user$userId', authorDataString);
        String authorData1= authorData[1];
        print('step_008 (NovelPage): authorName has been loaded, authorData [1] (name): $authorData1, saving to local storage');
        NetworkHandler().saveString('user', 'authorName$userId',authorData[1]);
        setState(() {
          author= AppFunctions().convertToTitleCase(authorData[1]);
          print('step_009 (NovelPage): author data has been updated, author: $author');
          authorLoading=false;
        });
      } else {
        print('step_008 (NovelPage-interrupted): authorData has failed to load, returning error');
        setState(() {
          authorLoading=false;
          author= 'error';
        });
      }
    }
  }

  List<Widget> getCommentList(double width, List<List<String>> commentData) {
    List<Widget> commentList= [];
    if (!commentLoading && isThereAnyComment && !errorOnLoadingCommentData) {
      for (int i=0; i<commentData.length; i++) {
        commentList.add(SizedBox(
          width: width,
          child: Column(
            children: [
              SizedBox(
                  height: 40,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundImage: MemoryImage(AppFunctions().convertBase64Image(commentatorDataList[i][3]))),
                        Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            height: 40,
                            width: 150,
                            child: Text(commentatorDataList[i][1], style: const TextStyle(fontSize: 18, color: Colors.black), overflow: TextOverflow.ellipsis)),
                      ]
                  )
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(commentData[i][2], style: TextStyle(fontSize: 18, color: AppTheme.themeColor))
              ),
            ],
          ),
        ));
      }
    }  else if (!commentLoading && !isThereAnyComment) {
      commentList.add(SizedBox(
        width: width,
        height: 100,
        child: Center(
          child: Text('There is no comment yet. Be the first!', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        ),
      ));
    }  else if (!commentLoading && errorOnLoadingCommentData) {
      commentList.add(SizedBox(
        width: width,
        height: 100,
        child: Center(
          child: Text('Network Error', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        ),
      ));
    } else if (commentLoading) {
      commentList.add(SizedBox(
        width: width,
        height: 100,
        child: Center(
          child: Text('Loading...', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        ),
      ));
    }
    return commentList;
  }

  Future<void> getCommentData(String novelId) async{
    String token= widget.token;
    List<List<String>> commentDataOnLoad= await NetworkHandler().getSubPostByParentId(token, novelId, 0);
    if (commentDataOnLoad[0][0]!='error' && commentDataOnLoad[0][0]!='zero') {
      setState(() {
        commentData= commentDataOnLoad;
      });
      getCommentatorData(commentDataOnLoad);
    } else if (commentDataOnLoad[0][0]!='zero') {
      setState(() {
        isThereAnyComment= false;
      });
    } else {
      setState(() {
        errorOnLoadingCommentData= true;
      });
    }
  }

  Future<void> getCommentatorData(List<List<String>> commentData) async{
    List<List<String>> commentatorDataListOnLoad= [];
    List<String> commentatorData= [];
    for (int i=0; i<commentData.length; i++) {
      String userId= commentData[i][1];
      String? commentator= await NetworkHandler().getString('user', 'user$userId');
      if (commentator==null) {
        commentatorData= await NetworkHandler().getUser(widget.token, userId);
        if (commentatorData[0][0]!='zero' && commentatorData[0][0]!='error') {
          String commentatorDataString= commentatorData.join('<divider%61>');
          NetworkHandler().saveString('user', 'user$userId', commentatorDataString);
        } else {
          setState(() {
            errorOnLoadingCommentatorData=true;
            errorOnLoadingCommentData= true;
          });
        }
      } else {
        commentatorData= commentator.split('<divider%61>');
      }
    }
    commentatorDataListOnLoad.add(commentatorData);
    setState(() {
      commentatorDataList= commentatorDataListOnLoad;
      commentLoading=false;
    });
  }
}
