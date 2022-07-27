import 'dart:math';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'RootPage.dart';
import 'RegisterPage.dart';

//auth page constructor
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

//auth page state
class _AuthPageState extends State<AuthPage> {
  final List<Widget> loginLoadingWidgetArray= [
    const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
    const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(backgroundColor: Colors.white))
  ];
  final List<Widget> registerLoadingWidgetArray =[
    const Text('Register', style: TextStyle(fontSize: 20, color: Colors.white)),
    const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(backgroundColor: Colors.white))
  ];
  var loginLoadingState= 0;
  var registerLoadingState= 0;
  var message= 'something went wrong';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //scaffold
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fictuneBackground2.PNG"),
                  fit: BoxFit.cover
                )
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black54,
            child: Center(
              child: SizedBox(
                height: 400,
                width: size.width,
                child: Column(
                  children: [
                    Container(
                        height: 360,
                        width: min(310, size.width*0.76),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              title(),
                              inputTextField('email', emailController),
                              purpleLine(),
                              inputTextField('password', passwordController),
                              purpleLine(),
                              button(),
                              loginWithOtherMethod()

                            ]
                        )
                    ),
                    SizedBox(
                        height: 40,
                        width: 310,
                        child: Center(
                            child: SizedBox(
                              width: 246,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Don't have account?", style: TextStyle(fontSize: 18, color: Colors.white)),
                                  GestureDetector(
                                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterPage()));},
                                    child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromRGBO(50, 0, 100, 1)),
                                        width: 80,
                                        child: Center(
                                          child: registerLoadingWidgetArray[registerLoadingState],
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ))
                    )
                  ]
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  //components:
  //tittle widget
  Widget title() {
    return(
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 15),
            child: Text('Login to Fictune', style: TextStyle(fontSize: 24, color: Color.fromRGBO(50, 0, 100,1), fontWeight: FontWeight.bold))
        )
    );
  }

  //input text widget
  Widget inputTextField(String string, controller) {
    return(
        Container(
          margin: const EdgeInsets.only(left: 30, top: 25, right: 30, bottom: 0),
          height: 28,
          child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: string
              )
          ),
        )
    );
  }

  //line widget
  Widget purpleLine() {
    var size= MediaQuery.of(context).size;
    return(
        Container(
            height: 1,
            width: min(246, size.width*0.76 -60),
            color: const Color.fromRGBO(50, 0, 100, 1)
        )
    );
  }

  //button widget
  Widget button() {
    return(
        GestureDetector(
          onTap: () async {
            setState(() {
              loginLoadingState= 1;
            });
            String typedEmail= emailController.text;
            String typedPassword= passwordController.text;
            var response= await NetworkHandler().login('login', {'email': typedEmail, 'password': typedPassword});
            List<String> responseList= response;
            if (responseList[0]!= 'success') {
              setState(() {message= responseList[1]; loginLoadingState= 0;});
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message));
            } else {
              setState(() {loginLoadingState= 0;});
              Navigator.push(context, MaterialPageRoute(builder: (context)=> RootPage(responseList: responseList)));
            }
          },
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromRGBO(50, 0, 100, 1)),
                      width: 90,
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Center(
                          child: loginLoadingWidgetArray[loginLoadingState],
                      )
                  )
              )
          ),
        )
    );
  }

  //snack-bar widget
  SnackBar snackBarWidget(String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          setState(() {loginLoadingState=0;});
        },
      ),
    );
    return snackBar;
  }

  //login with other method widget
  Widget loginWithOtherMethod() {
    return Column(
      children: [
        const SizedBox(height: 15),
        SizedBox(
            height: 25,
            child: Text("or login using google or facebook", style: TextStyle(fontSize: 15, color: AppTheme.themeColor))
        ),
        SizedBox(
          width: 92,
          child: Row(
              children: [
                GestureDetector(
                  onTap: googleLoginFunction(),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/google.png'),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: facebookLoginFunction(),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/facebook.PNG'),
                    radius: 20,
                  ),
                )
              ]
          ),
        ),
      ],
    );
  }

  //google login function
  void Function()? googleLoginFunction() {
    return null;

    //for 14 july 's work
  }

  //facebook login function
  void Function()? facebookLoginFunction() {
    return null;

    //for 14 july 's work
  }
}
