import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'RootPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<Widget> registerLoadingWidgetArray =[
    const Text('Register', style: TextStyle(fontSize: 20, color: Colors.white)),
    const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(backgroundColor: Colors.white))
  ];
  var registerLoadingState= 0;
  var message= 'something went wrong';
  final emailController = TextEditingController();
  final nameController= TextEditingController();
  final passwordController = TextEditingController();
  final passConfirmController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.2,
              width: size.width,
              child: Center(
                  child: Text('Register to Fictune', style: TextStyle(fontSize: 24, color: AppTheme.themeColor, fontWeight: FontWeight.bold))
              ),
            ),
            SizedBox(
              height: size.height*0.65,
              width: size.width,
              child: Column(
                  children: [
                    inputTextField('email', emailController),
                    purpleLine(),
                    inputTextField('name', nameController),
                    purpleLine(),
                    inputTextField('password', passwordController),
                    purpleLine(),
                    inputTextField('password confirmation', passConfirmController),
                    purpleLine(),
                    button(),
                    registerWithOtherMethod()
                  ]
              )
            ),
          ]
        )
      )
    );
  }

  //sub-widgets:
  //input field
  Widget inputTextField(String string, controller) {
    var size= MediaQuery.of(context).size;
    return(
        Container(
          margin: const EdgeInsets.only(left: 60, top: 25, right: 60, bottom: 0),
          height: 28,
          width: size.width,
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

  //purple line
  Widget purpleLine() {
    var size= MediaQuery.of(context).size;
    return(
        Container(
            height: 1,
            width: size.width-120,
            color: const Color.fromRGBO(50, 0, 100, 1)
        )
    );
  }

  //register button
  Widget button() {
    return(
        GestureDetector(
          onTap: () async {
            setState(() {
              registerLoadingState= 1;
            });
            String typedEmail= emailController.text;
            String typedName= nameController.text;
            String typedPassword= passwordController.text;
            String typedPassConfirm= passConfirmController.text;
            print(emailController.text);
            if (emailController.text=='' || nameController.text=='') {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('email and name cannot be empty'));
              setState(() {registerLoadingState= 0;});
            } else if (passwordController.text=='') {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('password cannot be empty'));
              setState(() {registerLoadingState= 0;});
            }
            if (typedPassConfirm!=typedPassword && registerLoadingState==1) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('your confirmation password does not match to your password'));
              setState(() {registerLoadingState= 0;});
            } else if (registerLoadingState==1) {
              var response= await NetworkHandler().register('register', {'email': typedEmail, 'name': typedName, 'password': typedPassword});
              List<String> responseList= response;
              if (responseList[0]!= 'success') {
                setState(() {message= 'email or password is incorrect'; registerLoadingState= 0;});
                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message));
              } else {
                setState(() {registerLoadingState= 0;});
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RootPage(responseList: responseList)));
              }
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
                        child: registerLoadingWidgetArray[registerLoadingState],
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
          setState(() {registerLoadingState=0;});
        },
      ),
    );
    return snackBar;
  }

  //register with other method widget
  Widget registerWithOtherMethod() {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      height: 170,
      width: size.width,
      child: Center(
        child: SizedBox(
          width: 400,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('or register using google or facebook', style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
              const SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/google.png'),
                        radius: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/facebook.PNG'),
                        radius: 20,
                      ),
                    )
                  ]
              ),
            ],
          ),
        ),
      )
    );
  }
}

