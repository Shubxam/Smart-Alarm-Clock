// import 'package:alarm_clock_app/AlarmData.dart';
import 'package:alarm_clock_app/AlarmRing.dart';
import 'package:alarm_clock_app/notes.dart';
import 'package:flutter/material.dart';
import './CardUI.dart';
import './AlarmData.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import './Setting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:intl/intl.dart';
import 'package:background_fetch/background_fetch.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Hive Initialization
  final appStorageDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appStorageDir.path);
  Hive.registerAdapter(AlarmAdapter());
  final alarmBox = await Hive.openBox('alarmBox');
  final faceData = await Hive.openBox('faceData');
  if (alarmBox.length < 2) {
    alarmBox.add(alarmList[0]);
    alarmBox.add(alarmList[1]);
  }

  //BackgroundFetch Initialization
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  //NotificationsInitialization
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color(0xffe9f080),
          secondary: Color(0xffe9f080),
          background: Color(0xff3a3e3b),
          surface: Color(0xff32444b),
          onPrimary: Color(0xff000000),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xffffffff),
        ),
      ),
      title: "Alarm Clock",
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: MyAppHome(),
      ),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  bool alarmsActive = true;

  @override
  void initState() {
    super.initState();
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmRingScreen(
                  payload: payload,
                  notificationPlugin: flutterLocalNotificationsPlugin,
                )),
      );
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // void initPlatformState() async {
  //   try {
  //     await BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //         minimumFetchInterval: 1,
  //         enableHeadless: true,
  //         forceAlarmManager: true,
  //         requiresDeviceIdle: false,
  //         stopOnTerminate: false,
  //         // requiredNetworkType: NetworkType.NONE,
  //         requiresBatteryNotLow: false,
  //         requiresCharging: false,
  //         requiresStorageNotLow: false,
  //         startOnBoot: true,
  //       ),
  //       (String taskId) {
  //         var time = DateTime.now().toUtc();
  //         switch (taskId) {
  //           case 'ScheduledAlarm':
  //             print("Custom Scheduled Task");
  //             // sendNotification();
  //             break;
  //           default:
  //             print("[BackgroundFetch] Event received $taskId at $time");
  //         }

  //         // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //         BackgroundFetch.finish(taskId);
  //       },
  //     );
  //   } on Exception catch (err) {
  //     print('[BackgroundFetch] configure error: $err');
  //   }
  // }

  // void customAlarmScheduleTask() async {
  //   await BackgroundFetch.scheduleTask(
  //       TaskConfig(taskId: 'ScheduledAlarm', delay: 5000));
  // }

  void scheduleNotification() {
    final alarmBox = Hive.box('alarmBox');
    for (int i = 0; i < alarmBox.length; i++) {
      var alarm = alarmBox.getAt(i);
      if(alarm.state){
        sendNotification(alarm.time, alarm.label);
        print("Alarm to be set for - ${alarm.time}");
      }
      
      
    }
  }

  void sendNotification(DateTime time, String label) async {
    var _label = label;
    var _time = DateTime(time.year, time.month, time.day, time.hour, time.minute, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'id',
      'Alarm',
      'Notification When Alarm Rings',
      autoCancel: false,
      channelShowBadge: true,
      enableVibration: true,
      importance: Importance.Max,
      ongoing: true,
      // playSound: true,
      visibility: NotificationVisibility.Public,
      sound: 'custom_ring',
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    if (time.isBefore(DateTime.now())) {
      return;
    }
    await flutterLocalNotificationsPlugin.schedule(
      0,
      '${DateFormat.Hm().format(_time)}',
      _label,
      _time,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: 'onTap',
    );
    print("Alarm set for $_time");
  }

  // void toggleAlarmsActiveState(bool state) async {
  //   setState(() {
  //     alarmsActive = state;
  //   });
  //   alarmsActive = !state;

  //   if (alarmsActive) {
  //     try {
  //       int status = await BackgroundFetch.start();
  //       print('[BackgroundFetch] start success: $status');
  //     } on Exception catch (e) {
  //       print('[BackgroundFetch] start FAILURE: $e');
  //     }
  //   } else {
  //     int status = await BackgroundFetch.stop();
  //     print('[BackgroundFetch] stop success: $status');
  //   }
  // }

  var currentScreen = 1;

  void changeScreen(screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  List<Widget> screens = [
    NotesWidget(),
    CardUI(),
    Setting(),
  ];


  @override
  Widget build(BuildContext context) {
    // initPlatformState();
    scheduleNotification();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 29, 15, 0),
            child: SizedBox(
              height: 35,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Alarmy",
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          screens[currentScreen],
        ],
      ),
      bottomNavigationBar: FancyBottomNavigation(
        onTabChangedListener: (position) {
          changeScreen(position);
        },
        tabs: [
          TabData(iconData: Icons.note_add, title: "Notes"),
          TabData(iconData: Icons.alarm, title: "Alarms"),
          TabData(iconData: Icons.settings, title: "Setting"),
        ],
        circleColor: Theme.of(context).colorScheme.primary,
        barBackgroundColor: Theme.of(context).colorScheme.background,
        activeIconColor: Colors.black,
        initialSelection: 1,
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

}
