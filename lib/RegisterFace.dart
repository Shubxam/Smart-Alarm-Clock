import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:hive/hive.dart';


class RegisterFace extends StatefulWidget {
  @override
  _RegisterFaceState createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  File _image;
  List<Face> _faces = [];
  FaceDetector faceDetector;
  final faceBox = Hive.box('faceData');

  void getImageAndDetectFaces() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    final visionImage = FirebaseVisionImage.fromFile(image);
    faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.fast,
        enableClassification: true,
        enableLandmarks: true,
        // enableContours: true,
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
      
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 40),
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

                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: _faces.length != 0
                    ? Column(
                        children: <Widget>[
                          Text(
                            "No of faces detected : ${_faces.length}\nLeft Eye OpenProbability : ${(_faces[0].leftEyeOpenProbability).toStringAsPrecision(5)} \nRight Eye OpenProbability : ${(_faces[0].rightEyeOpenProbability).toStringAsPrecision(5)}",
                          ),
                          SizedBox(height : 20),
                          RaisedButton(
                            
                            onPressed: () {
                              faceBox.put('leftEyeProb',
                                  _faces[0].leftEyeOpenProbability);
                              print(_faces.length);
                              print("LEP set - ${_faces[0].leftEyeOpenProbability}");
                              faceBox.put('rightEyeProb',
                                  _faces[0].rightEyeOpenProbability);
                              print("REP set - ${_faces[0].rightEyeOpenProbability}");

                              Navigator.pop(context);
                            },
                            child: Text("Save Face Data"),
                          ),
                        ],
                      ) : Text("No faces detected"),
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

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }
}