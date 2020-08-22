// ERROR : Cant delete alarms range error shows up.
// ERROR : Can't add alarms, screen stops sliding, invisible layer shows up on the stack

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import './AlarmData.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import './main.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class AlarmDetail extends StatefulWidget {
  final int currentAlarmCard;
  Function removeAlarmFromList;
  AlarmDetail(this.currentAlarmCard, this.removeAlarmFromList);
  @override
  _AlarmDetailState createState() => _AlarmDetailState();
}

class _AlarmDetailState extends State<AlarmDetail> {
  final alarmBox = Hive.box('alarmBox');

  // var repeatSwitchState = false;
  var days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  void modifyAlarmRepeat(int day) {
    var alarmCard = alarmBox.getAt(widget.currentAlarmCard);
    setState(() {
      alarmCard.repeat.contains(day)
          ? alarmCard.repeat.remove(day)
          : alarmCard.repeat.add(day);
    });

    (alarmCard.repeat).sort();
  }

  // void repeatSwitchStateChange(bool state) {
  //   if (!repeatSwitchState) {
  //     setState(() {
  //       repeatSwitchState = true;
  //     });
  //   } else {
  //     setState(() {
  //       repeatSwitchState = false;
  //     });
  //   }
  // }

  List<Widget> get repeatDaysWidget {
    var alarmCard = alarmBox.getAt(widget.currentAlarmCard);
    List<Widget> repeatDaysWidgetList = [];
    for (int i = 0; i < 7; i++) {
      repeatDaysWidgetList.add(
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: RawMaterialButton(
            onPressed: () => modifyAlarmRepeat(i),
            child: Text(
              "${days[i]}",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            disabledElevation: 0.0,
            elevation: 5.0,
            enableFeedback: true,
            shape: CircleBorder(),
            fillColor: alarmCard.repeat.contains(i) ? Colors.white : null,
          ),
        ),
      );
    }
    return repeatDaysWidgetList;
  }
  // Box<Alarm> alarmBox;
  // void initializeBox() async {
  //   alarmBox = await Hive.openBox('alarmBox');
  // }

  @override
  Widget build(BuildContext context) {
    // initializeBox();
    var alarmCard = alarmBox.getAt(widget.currentAlarmCard) as Alarm;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GradientCard(
        margin: EdgeInsets.all(0),
        gradient: Gradients.hotLinear,
        shadowColor: Gradients.hotLinear.colors.last.withOpacity(.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.2,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text(
                            "${alarmCard.label}",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          iconSize: 30,
                          onPressed: () {
                            if (alarmBox.length <= 2) {
                              return;
                            } else {
                              widget
                                  .removeAlarmFromList(widget.currentAlarmCard);
                              setState(() {
                                alarmBox.deleteAt(widget.currentAlarmCard);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppHome()));
                              });
                            }
                          },
                          tooltip: "Remove",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.20,
                    child: Text(
                      "${DateFormat.Hm().format(alarmCard.time)}",
                      style: GoogleFonts.merriweather(
                          letterSpacing: 2,
                          fontSize: 40,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  // Container(
                  //   // height: constraints.maxHeight * .08,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //         // width: constraints.maxWidth * .2,
                  //         child: Text(
                  //           "Repeat : ",
                  //           style: TextStyle(
                  //               fontSize: 21, fontWeight: FontWeight.w600),
                  //         ),
                  //       ),
                  //       Container(
                  //         // width: constraints.maxWidth * .2,
                  //         child: CustomSwitch(
                  //           value: repeatSwitchState,
                  //           onChanged: (bool state) =>
                  //               repeatSwitchStateChange(state),
                  //           activeColor: Theme.of(context).backgroundColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                      // height: constraints.maxHeight * .01,
                      ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Text("Repeat : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)],
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * .1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: repeatDaysWidget,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * .15,
                    // width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Off'),
                        Switch(
                            value: alarmCard.state,
                            onChanged: (newState) {
                              setState(
                                () {
                                  alarmCard.state = newState;
                                },
                              );
                            }),
                        Text('On'),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
