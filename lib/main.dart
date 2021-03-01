import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roster_app/pages/dashboard.dart';
import 'package:roster_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(MyApp());
  // DynamicLinkService().handleDynamicLinks();
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roster',
      theme: ThemeData(
        primarySwatch:  MaterialColor(0xFF401461, {
          50:  Color(0xFF401461),
          100: Color(0xFF401461),
          200: Color(0xFF401461),
          300: Color(0xFF401461),
          400: Color(0xFF401461),
          500: Color(0xFF401461),
          600: Color(0xFF401461),
          // 600: Color(0xFF401461),
          700: Color(0xFF401461),
          800: Color(0xFF401461),
          900: Color(0xFF401461),
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "3c",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences mPref;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // final Location location = Location();
  // getFcmToken()async{
  //   mPref = await SharedPreferences.getInstance();
  //   _firebaseMessaging.getToken().then((token){
  //     print(token);
  //     mPref.setString('firebase_token', token);
  //   });
  //
  // }

 goToNextPage() async{
   mPref = await SharedPreferences.getInstance();
   bool checkLoginStatus = mPref.get("login_status");
   if(checkLoginStatus == null){
     checkLoginStatus = false;
   }
   if(checkLoginStatus){
     SchedulerBinding.instance.addPostFrameCallback((_) {
       Navigator.push(
           context,
           new MaterialPageRoute(
               builder: (context) => Dashboard()));
     });
   }
   else {
     SchedulerBinding.instance.addPostFrameCallback((_) {
       Navigator.push(
           context,
           new MaterialPageRoute(
               builder: (context) => Login()));
     });
   }
 }

  @override
  void initState() {
    super.initState();
    // getFcmToken();
    // openLocationSetting();
    Timer(
        Duration(seconds: 3),
    ()async{
      mPref = await SharedPreferences.getInstance();
      bool checkLoginStatus = mPref.get("login_status");
      if(checkLoginStatus == null){
        checkLoginStatus = false;
      }
      if(checkLoginStatus){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Dashboard()));
      }
      else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login()));
      }
    });
  }

  // void openLocationSetting() async {
  //   bool serviceStatus = await location.serviceEnabled();
  //   if (serviceStatus) {
  //     // service enabled
  //   } else {
  //     // service not enabled, restricted or permission denied
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFffffff),
        child:Image.asset('assets/images/splash_icon.png')
    );
  }
}
