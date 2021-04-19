import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:push_notification_app/model/push_model.dart';
import 'package:push_notification_app/notification_badge.dart';

void main() {
  runApp(MyApp());
}

PushNotification _notificationInfo;
int _totalNotifications;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}











Future<dynamic> _firebaseMessagingBackgroundHandler(
    Map<String, dynamic> message,
    ) async {
  // Initialize the Firebase app
  await Firebase.initializeApp();
  print('onBackgroundMessage received: $message');
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // TODO: Below new added code from SECOND TUTORIAL!!!
  FlutterLocalNotificationsPlugin fltrNotification;
  String _selectedParam;
  String task;
  int val;
  // TODO: Above new added code from SECOND TUTORIAL!!!






  FirebaseMessaging _messaging = FirebaseMessaging();

  void registerNotification() async {
    // Initialize the Firebase app
    await Firebase.initializeApp();

    // On iOS, this helps to take the user permissions
    await _messaging.requestNotificationPermissions(
      IosNotificationSettings(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      ),
    );

    // For handling the received notifications
    _messaging.configure(
      onMessage: (message) async {
        print('ON_MESSAGE RECEIVED: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        // For displaying the notification as an overlay
        showSimpleNotification(
          Text(_notificationInfo.title),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_notificationInfo.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
        );
      },
      onBackgroundMessage: _firebaseMessagingBackgroundHandler,
      onLaunch: (message) async {
        print('ON_LAUNCH: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
      onResume: (message) async {
        print('ON_RESUME: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
    );

    // Used to get the current FCM token
    _messaging.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _totalNotifications = 0;
    registerNotification();
    super.initState();

    // TODO: Below added new code from SECOND TUTORIAL!!!
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    // TODO: Above added new code from SECOND TUTORIAL!!!
  }

  // TODO: Delete below code!
  void onClick() {
    // popup a toast.
    toast('Hello world!');

    // show a notification at top of screen.
    showSimpleNotification(
        Text("this is a message from simple notification"),
        background: Colors.green);
  }
  // TODO: Delete above code!

  @override
  Widget build(BuildContext context) {

    // TODO: Below new added code from SECOND TUTORIAL!!!
    Future _showNotification() async {
      var androidDetails = new AndroidNotificationDetails(
          "Channel ID", "Desi programmer", "This is my channel",
          importance: Importance.max);
      var iSODetails = new IOSNotificationDetails();
      var generalNotificationDetails =
      new NotificationDetails(android: androidDetails, iOS: iSODetails);

      var scheduledTime;
      if (_selectedParam == "Hour") {
        scheduledTime = DateTime.now().add(Duration(hours: val));
      } else if (_selectedParam == "Minute") {
        scheduledTime = DateTime.now().add(Duration(minutes: val));
      } else {
        scheduledTime = DateTime.now().add(Duration(seconds: val));
      }

      fltrNotification.schedule(
          1, "Times Uppp", task, scheduledTime, generalNotificationDetails);

      // await fltrNotification.show(
      //     0, "Task", "You created a Task",
      //     generalNotificationDetails, payload: "Task");
    }
// TODO: Above new added code from SECOND TUTORIAL!!!

    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 16.0),
          _notificationInfo != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TITLE: ${_notificationInfo.title ?? _notificationInfo.dataTitle}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BODY: ${_notificationInfo.body ?? _notificationInfo.dataBody}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  onClick();
                },
                child: Text('Click me'),
              ),
            ],
          )
              : Container(),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              onChanged: (_val) {
                task = _val;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton(
                value: _selectedParam,
                items: [
                  DropdownMenuItem(
                    child: Text("Seconds"),
                    value: "Seconds",
                  ),
                  DropdownMenuItem(
                    child: Text("Minutes"),
                    value: "Minutes",
                  ),
                  DropdownMenuItem(
                    child: Text("Hour"),
                    value: "Hour",
                  ),
                ],
                hint: Text(
                  "Select Your Field.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onChanged: (_val) {
                  setState(() {
                    _selectedParam = _val;
                  });
                },
              ),
              DropdownButton(
                value: val,
                items: [
                  DropdownMenuItem(
                    child: Text("1"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("2"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("3"),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    child: Text("4"),
                    value: 4,
                  ),
                ],
                hint: Text(
                  "Select Value",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onChanged: (_val) {
                  setState(() {
                    val = _val;
                  });
                },
              ),
            ],
          ),
          RaisedButton(
            onPressed: _showNotification,
            child: new Text('Set Task With Notification'),
          )

        ],
      ),
    );
  }

  // TODO: Below code related to SECOND TUTORIAL!!!
    Future notificationSelected(String payload) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Notification : $payload"),
        ),
      );
    }
  // TODO: Above code related to SECOND TUTORIAL!!!
}