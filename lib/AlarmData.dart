import 'package:hive/hive.dart';

part 'AlarmData.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  DateTime time;
  @HiveField(1)
  String label;
  @HiveField(2)
  bool state;
  @HiveField(3)
  List<int> repeat = [];

  Alarm({this.label = "Default", this.repeat, this.state, this.time});
}

List<Alarm> alarmList = [
  Alarm(
    label: "Morning-1",
    state: true,
    repeat: [],
    time: DateTime.now().add(
      Duration(minutes: 2),
    ),
  ),
  Alarm(
    label: "Afternoon-2",
    state: true,
    repeat: [],
    time: DateTime.now().add(
      Duration(hours: 3),
    ),
  ),
];
