import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class EmergencyExit extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationPlugin;
  EmergencyExit(this.notificationPlugin);
  @override
  _EmergencyExitState createState() => _EmergencyExitState();
}

class _EmergencyExitState extends State<EmergencyExit> {
  int counter = 0;
  int limit = 150;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Emergency Exit"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Click the button ${limit - counter} times more to stop the alarm"),
            SizedBox(height: 30,),
            RaisedButton(onPressed: () {
              counter == limit ?
              cancelAlarm()
              : setState(() {
                counter += 1;
              });
            },
            child: Text("Click Me"),)
          ],
        ),
      ),
    );
  }

  void cancelAlarm() async {
    await widget.notificationPlugin.cancelAll();
    Navigator.pop(context);
  }
}
