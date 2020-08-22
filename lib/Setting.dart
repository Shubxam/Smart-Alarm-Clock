import './RegisterFace.dart';
import 'package:flutter/material.dart';

// class Setting extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: Text("Setting"),
//         backgroundColor: Theme.of(context).colorScheme.background,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Card(
//             color: Colors.white,
//             elevation: 5,
//             margin: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
//             child: Center(
//               child: FlatButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RegisterFace(),
//                       ));
//                 },
//                 child: Text("Configure Face Data", style: TextStyle(color: Colors.black),),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          color: Colors.white,
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 35, horizontal: 18),
          child: Center(
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterFace(),
                    ));
              },
              child: Text(
                "Configure Face Data",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
