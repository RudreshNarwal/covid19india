import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title, @required this.analytics, @required this.observer})
      : super(key: key);
  final String title;
final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState(analytics, observer);
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState(this.analytics, this.observer);

final dateTime = DateTime.now();
var firestore = Firestore.instance;

final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
 String mobileNumber;
  var deviceId;



  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'Notification Received : $mobileNumber ',
      parameters: <String, dynamic>{
        'string': 'id: $mobileNumber',
        'bool': true,
      },
    );
  }


  Future<bool> setData() async {
    final snapShot = await Firestore.instance.collection('posts').document("$deviceId").get();
    if(snapShot.exists){
      return false;
    }else{
      Firestore.instance.collection('userData').document("$deviceId")
         .setData({ 'mobile': '$mobileNumber', deviceId: '$deviceId', 'dateTime': '$dateTime' });
         return true;
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage called: $message');
        _sendAnalyticsEvent();
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume called: $message');
        _sendAnalyticsEvent();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch called: $message');
        _sendAnalyticsEvent();
      },
    );
    firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
      setState(() {
        deviceId = token;
      });
    });
     setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: WebviewScaffold(
                  url: 'https://www.covid19india.org/',
                  withZoom: true,
                  withLocalStorage: true,
                  hidden: true,
                  initialChild: Center(child: CircularProgressIndicator())),
            )));
  }
}

