import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:hive/hive.dart';
import './EmergencyExit.dart';
import './main.dart';

class AlarmRingScreen extends StatefulWidget {
  final String payload;
  final FlutterLocalNotificationsPlugin notificationPlugin;
  AlarmRingScreen({this.payload, this.notificationPlugin});
  @override
  _AlarmRingScreenState createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  double leftEye;
  File _image;
  List<Face> _faces = [];
  FaceDetector faceDetector;
  final faceData = Hive.box('faceData');

  void getImageAndDetectFaces() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    final visionImage = FirebaseVisionImage.fromFile(image);
    faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.fast,
        enableClassification: true,
        enableLandmarks: true,
        enableContours: false,
      ),
    );
    List<Face> faces = await faceDetector.processImage(visionImage);

    if (mounted) {
      setState(() {
        _image = image;
        _faces = faces;
      });
    }
  }
  //1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Turn Off Alarm"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.error_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmergencyExit(widget.notificationPlugin)));
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white,),borderRadius: BorderRadius.circular(10)),
                constraints: BoxConstraints.expand(),
                child: Center(
                  child: _image == null
                      ? Text("No Image Selected")
                      : Image.file(_image),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                // color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: _faces.length != 0 && compareFace()
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: 40,),
                          Text("Success!! \n "),
                          RaisedButton(
                            onPressed: () async {
                              await widget.notificationPlugin.cancelAll();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppHome()));
                            },
                            child: Text("STOP ALARM"),
                          ),
                        ],
                      )
                    : _image == null
                        ? Center(child: Text("Pick an image."))
                        : Center(child: Text("Error! Try Again.")),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndDetectFaces,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  bool compareFace() {
    var lEProb = faceData.get("leftEyeProb");
    print("lEProb - $lEProb");

    var rEProb = faceData.get("rightEyeProb");
    print("rEProb - $rEProb");

    if (_faces[0].leftEyeOpenProbability > (lEProb - (lEProb * .05)) &&
        _faces[0].rightEyeOpenProbability > (rEProb - (rEProb * .05))) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // faceDetector.close();
    super.dispose();
  }
}
