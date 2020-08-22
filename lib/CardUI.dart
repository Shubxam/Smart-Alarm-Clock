import 'package:flutter/material.dart';
import './AlarmDetail.dart';
import './AlarmData.dart';
import 'package:card_selector/card_selector.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hive/hive.dart';
import './main.dart';
// import 'package:hive_flutter/hive_flutter.dart';

//Problems - If there's less than 2 alarms then swipe system won't work
//Todo : If there are no alarms, Instead Display text widget "No Alarms"

class CardUI extends StatefulWidget {
  @override
  _CardUIState createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> {
  final alarmBox = Hive.box("alarmBox");
  List<int> repeatDaysList;
  final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  double _width = 0;
  double _height = 0;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    List<Widget> alarmCards = [];
    void removeWidgetFromAlarmList(int alarmCard){
      setState(() {
        alarmCards.removeAt(alarmCard);
      });
    }

    for (int i = 0; i < alarmBox.length; i++) {
      var alarmCard = alarmBox.getAt(i);
      print("$i - ${alarmCard.label} \n ${alarmBox.length}");
      alarmCards.add(Container(
        child: AlarmDetail(i, removeWidgetFromAlarmList),
      ));
    }

    return Padding(
      padding: EdgeInsets.only(
        top: _height * .05,
      ),
      child: Column(
        children: <Widget>[
          CardSelector(
            cards: alarmCards,
            mainCardWidth: _width * .85,
            mainCardHeight: _width * .9,
            mainCardPadding: 20,
            cardsGap: 10,
          ),
          SizedBox(
            height: _height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 30.0),
                height: 45,
                child: RaisedButton(
                  elevation: 10,
                  onPressed: () => addAlarmCard(),
                  child: Text(
                    "Add Alarm",
                    style: TextStyle(fontSize: 24),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void modifyAlarmRepeat(int day) {
  //   repeatDaysList.add(day);

  //   (alarmCard.repeat).sort();
  // }

  // List<Widget> get repeatDaysWidget {
  //   List<Widget> repeatDaysWidgetList = [];
  //   for (int i = 0; i < 7; i++) {
  //     repeatDaysWidgetList.add(
  //       Flexible(
  //         fit: FlexFit.tight,
  //         flex: 1,
  //         child: RawMaterialButton(
  //           onPressed: () {
  //             repeatDaysList.add(i);
  //             repeatDaysList.sort();
              
  //           },
  //           child: Text(
  //             "${days[i]}",
  //             style: TextStyle(color: Colors.white, fontSize: 14),
  //           ),
  //           disabledElevation: 0.0,
  //           elevation: 5.0,
  //           enableFeedback: true,
  //           shape: CircleBorder(),
  //           fillColor: null,
  //         ),
  //       ),
  //     );
  //   }
  //   return repeatDaysWidgetList;
  // }

  void addAlarmCard() {
    var _time = DateTime.now();
    final labelController = TextEditingController();
    Alert(
      style: AlertStyle(
          isOverlayTapDismiss: true,
          animationType: AnimationType.grow,
          isCloseButton: true,
          titleStyle: TextStyle(fontSize: 28, letterSpacing: 4)),
      context: context,
      title: "Add New Alarm",
      type: AlertType.none,
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                TimePickerSpinner(
                  time: _time,
                  is24HourMode: false,
                  normalTextStyle: TextStyle(fontSize: 20, color: Colors.white),
                  highlightedTextStyle:
                      TextStyle(fontSize: 26, color: Colors.yellow),
                  spacing: 0,
                  itemHeight: 50,
                  isForce2Digits: true,
                  onTimeChange: (DateTime time) {
                    _time = time;
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15.0),
            //   child: Row(
            //     children: repeatDaysWidget,
            //   ),
            // ),
            Container(
              child: TextField(
                controller: labelController,
                decoration: InputDecoration(labelText: "Alarm Label"),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
            child: Text("OK"),
            onPressed: () {
              addAlarm(Alarm(
                time: _time.toLocal(),
                label: (labelController.text).length != 0 ? labelController.text : 'Label',
                repeat: [],
                state: true,
              ));
              // setState(() {
              //   // Navigator.of(context).pop();
              //   // print("POP Executed");
              //   rebuild();
              // });
              rebuild();
            }),
      ],
      closeFunction: () {},
    ).show();
  }

  //TODO :  App needs restart after adding every new alarm to show it on screen.
  void addAlarm(newAlarm) {
    setState(() {
      alarmBox.add(newAlarm);
      print("${alarmBox.length} \n ${newAlarm.time} \n ${newAlarm.label}");
    });
  }

  void rebuild() {
    print("PUSH Executed");
    Navigator.of(context)
        .push( MaterialPageRoute(builder: (BuildContext context) {
      return MyAppHome();
    }));
  }
}
