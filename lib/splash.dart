import 'dart:async';
import 'package:covid19india/home.dart';
import 'package:flutter/material.dart';


class SplashScreenFirst extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

enum UniLinksType { string, uri }

class SplashScreenState extends State<SplashScreenFirst>
    with SingleTickerProviderStateMixin {


  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }
 Future navigationPage() async {
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(bottom: 60.0),child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.asset(
                          'assets/images/ProductOf.png',
                          fit: BoxFit.fill,
                          height: 35,
                          width: 135,
                        ),))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.asset(
                          'assets/images/2.png',
                          width: animation.value * 450,
                          height: animation.value * 85,
                        ),)
                      ],
                    ),
                  ],
                ),
              )
            );
  }
}

