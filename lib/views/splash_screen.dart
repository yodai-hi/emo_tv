import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/views/top_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging();


  @override
  void initState(){
    super.initState();
    // ここで通知許可の設定を行う
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    // iOSの設定
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    _getUser(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }


  void _getUser(BuildContext context) async {
    try {
      firebaseUser = await _auth.currentUser();
      if (firebaseUser == null) {
        await _auth.signInAnonymously();
        firebaseUser = await _auth.currentUser();
      }
      changeMainScreen(context);
    }catch(e){
      changeLoginScreen(context);
    }
  }

  void changeMainScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Null>(
        builder: (BuildContext context) => TopScreen(auth: Auth()),
      ),
    );
  }

  void changeLoginScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Null>(
        builder: (BuildContext context) => LoginScreen(auth: Auth()),
      ),
    );
  }
}

