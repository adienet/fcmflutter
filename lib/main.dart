//import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  
  @override
void initState() {
  super.initState();
  _firebaseCloudMessaging_Listeners();
  _localNotificationInit();
}

void _localNotificationInit(){
  var initializationSettingsAndroid = new AndroidInitializationSettings('launch_background');
  var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

}

Future _showNotification(String paylod, String title, String message) async {
  var androidPlatformChannelSpecifics = 
  new AndroidNotificationDetails('channelid', 'channelName', 'channelDescription',
  importance: Importance.Max, priority: Priority.High);

  var iosPlatformChannelSpecifics =
  new IOSNotificationDetails();

  var platformChannelSpecific = 
  new NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, title, message, platformChannelSpecific, 
  payload: 'Default_Sound');

}

// ignore: non_constant_identifier_names
void _firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) _iOS_Permission();

  _firebaseMessaging.getToken().then((token){
    print(token);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('0 message $message');
      print(message);
      var data = message['notification'] ?? message;
      print(data);
      String title = data['title'];
      String body = data['body'];
      _showNotification('payload', title,body);
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

// ignore: non_constant_identifier_names
void _iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });
}

  @override
  Widget build(BuildContext context) {
    
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
                new RaisedButton(
                onPressed: (){
                  FutureBuilder<dynamic>(
                    future: _showNotification("ss","title","message"),
                    builder: (context, snapshot){
                      return;
                    }
                  );
                },
                child: new Text('Show Notification With Sound'),
                ),
              ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
