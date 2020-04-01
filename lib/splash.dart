import 'dart:async';
import 'package:covid19india/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';


class SplashScreenFirst extends StatefulWidget {
  SplashScreenFirst({Key key, this.analytics, this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  SplashScreenState createState() => new SplashScreenState(analytics, observer);
}


class SplashScreenState extends State<SplashScreenFirst>
    with SingleTickerProviderStateMixin {

SplashScreenState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }
 Future navigationPage() async {
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage(analytics: analytics, observer: observer,)),
  );
  }

  @override
  void initState() {
    super.initState();
       animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    startTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body:  WillPopScope(
                onWillPop: () async => false,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    //     Padding(padding: EdgeInsets.only(bottom: 60.0),child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //     child: Text(''),))
                    //   ],
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.asset(
                          'assets/covid19.png',
                          width: animation.value * 350,
                          height: animation.value * 350,
                        ),)
                      ],
                    ),
                  ],
                ),
              )
            );
  }
}

