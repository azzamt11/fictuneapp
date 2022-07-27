import 'dart:convert';
import 'dart:typed_data';

import '../network_and_data/NetworkHandler.dart';

class AppFunctions {
  //string-image conversion
  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= const Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }

  //get data function
  Future<void> getData(String token) async{
    //favorite novel data
    List<String> userLikedNovelIndices= await NetworkHandler().getUserLikedNovelIndices(token);
    String key0= 'userLikedNovelsIndices';
    if (userLikedNovelIndices[0]!='error' && userLikedNovelIndices[0]!='zero') {
      List<String> userLikedNovelIndexList= userLikedNovelIndices[1].split('%');
      String value0= userLikedNovelIndices[1];
      print('step_001: user liked novel indices = '+ value0+ ' ...saving with key: $key0');
      NetworkHandler().saveString('user', key0, value0);
      for (int i=0; i<userLikedNovelIndexList.length; i++) {
        String key= 'novelData'+userLikedNovelIndexList[i];
        print('step_002: checking favorite novel data for index $i in storage for key: $key');
        String? ithLikedNovelDataString= await NetworkHandler().getString('user', key);
        if (ithLikedNovelDataString==null) {
          print('step_003: ithLikedNovelDataString for key $key not found in storage, getting favorite novel from network with index '+ userLikedNovelIndexList[i]);
          List<String> likedNovelDataForIthIteration= await NetworkHandler().getPostById(token, userLikedNovelIndexList[i]);
          if (likedNovelDataForIthIteration[0]=='success') {
            String userLikedNovelId= userLikedNovelIndexList[i];
            print('step_004: favorite novel data for $i th iteration success, saving in storage with key: $key');
            String ithLikedNovelDataString= '$userLikedNovelId<divider%83>'+ likedNovelDataForIthIteration[1]+ '<divider%83>'+likedNovelDataForIthIteration[2]+ '<divider%83>'+ likedNovelDataForIthIteration[3]+'<divider%83>'+ likedNovelDataForIthIteration[4]+'<divider%83>'+ likedNovelDataForIthIteration[5];
            NetworkHandler().saveString('user', key, ithLikedNovelDataString);
          } else {
            print('step_004b: favorite novel data for $i th iteration error/unsuccessful, it will be loaded in another try');
          }
        } else {
          print('step_003: favorite novel data found in storage, saving success');
        }
      }
    } else if (userLikedNovelIndices[0]=='zero') {
      print('step_001: user liked novel indices = zero  ...saving with key: $key0');
      NetworkHandler().saveString('user', key0, 'zero');
    } else {
      print('step_001: user liked novel indices = error not found');
    }

    //my novel data
    List<List<String>> myNovelData= await NetworkHandler().getUserNovels(token);
    String novelData= '';
    if (myNovelData[0][0]!='error' && myNovelData[0][0]!='zero') {
      for (int i=0; i<myNovelData.length; i++) {
        novelData= novelData+ myNovelData[0][1]+ '<divider%83>'+ myNovelData[0][2]+ '<divider%83>'+ myNovelData[0][3]+ '<divider%71>';
      }
      NetworkHandler().saveString('user', 'myNovelData', novelData);
    } else if (myNovelData[0][0]=='zero') {
      NetworkHandler().saveString('user', 'myNovelData', 'zero');
    } else {
      NetworkHandler().saveString('user', 'myNovelData', 'error');
    }
  }

  //capitalize first letter of each word function
  String convertToTitleCase(String text) {
    if (text.length <= 1) {
      return text.toUpperCase();
    }
    final List<String> words = text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);
        return '$firstLetter$remainingLetters';
      }
      return '';
    });
    return capitalizedWords.join(' ');
  }

}