import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

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

  const NotificationBadge({@required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$totalNotifications',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              onClick();
            },
            child: Text('Click me'),
          ),
        ],
      ),
    );
  }
}