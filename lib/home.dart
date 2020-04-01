import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:location/location.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();

  final Location location = new Location();
  PermissionStatus _permissionGranted;

  // num _stackToView = 1;

  // void _handleLoad(String value) {
  //   setState(() {
  //     _stackToView = 0;
  //   });
  // }

  _checkPermissions() async {
    PermissionStatus permissionGrantedResult = await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  _requestPermission() async {
    if (_permissionGranted != PermissionStatus.GRANTED) {
      PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.GRANTED) {
        return;
      }
    }
    _checkService();
    _requestService();
  }

  bool _serviceEnabled;

  _checkService() async {
    bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _requestPermission();
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage called: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume called: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch called: $message');
      },
    );
    firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });
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

