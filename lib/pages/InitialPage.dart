import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'AuthPage.dart';
import 'RootPage.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with SingleTickerProviderStateMixin{
  bool loadingState= true;
  int loadingCount=0;
  late AnimationController controller;
  late Animation<Color?> animation;
  double progress= 0;

  @override
  initState() {
    super.initState();

    controller= AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    animation= controller.drive(Tween<Color?>(begin: AppTheme.themeColor, end: AppTheme.themeColor));
    controller.repeat;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navigateToRootOrLogin(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fictuneLogo.png')
                    )
                ),
                height: 60,
                width: 50,
              ),
              SizedBox(
                width: 100,
                height: 10,
                child: LinearProgressIndicator(
                  valueColor: animation,
                  backgroundColor: const Color.fromRGBO(150, 45, 255, 1),
                )
              ),
            ]
          ),
        ),
      )

    );
  }

  Future<void> navigateToRootOrLogin(context) async{
    String? response1= await NetworkHandler().getString('user', 'token');
    if (response1!=null) {
      AppFunctions().getData(response1);
    }
    String? response2= await NetworkHandler().getString('user', 'user_name');
    String? response3= await NetworkHandler().getString('user', 'user_id');
    String? response4= await NetworkHandler().getString('user', 'user_attribute');
    String? response5= await NetworkHandler().getString('user', 'user_userdata');
    String? response6= await NetworkHandler().getString('user', 'user_userbillingdata');
    if (response1!=null && response2!=null && response3!=null && response4!=null&& response5!=null && response6!=null) {
      List<String> responseList= ['success', response1, response2, response3, response4, response5, response6];
      Navigator.push(context, MaterialPageRoute(builder: (context)=> RootPage(responseList: responseList)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthPage()));
    }
  }
}
