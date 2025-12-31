import 'package:driver_dashboard/ntcore/instance.dart';
import 'package:driver_dashboard/ntcore/values.dart';
import 'package:flutter/material.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {

  /* 
  dummy variables/functions
  too lazy to implement api rn
  */
  final int gameTime = 135; // in seconds

  void selectAuto({required String auto}) => setState(() {
     // select auto
  });
  

  String formatTime({required int timeInSeconds}) {
    return "${(timeInSeconds/60).round()}:${timeInSeconds%60}";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            padding: EdgeInsets.all(30),

            child: Row(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
            
                Column(
                  spacing: 30,
                  mainAxisAlignment: .center,
                  children: [

                    // these black containers are temporary
                    // they will be replaced by mjpeg streams
                    Container(
                      color: Colors.black,
                      width: 480, height: 360,
                      padding: EdgeInsets.all(10),
                      child: Text("Cam 1", style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),),
                    ),
                    Container(
                      color: Colors.black,
                      width: 480, height: 360,
                      padding: EdgeInsets.all(10),
                      child: Text("Cam 2", style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),),
                    ),
                  ],
                ),
            
              
                SizedBox(width: 200,),
            
                Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  spacing: 30,
                  children: [

                    // timer
                    Container(
                      width: 300, height: 150,
                      alignment: .center,
                      decoration: BoxDecoration(  
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: Text(formatTime(timeInSeconds: gameTime), style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: .bold
                        ),
                      ),
                    ),

                    // labels
                    Row(
                      spacing: 10,
                      children: [
                        LabelContainer(label: "label", data: "data"),
                        LabelContainer(label: "longerlabel", data: "longerdata"),
                        LabelContainer(label: "longestlabel!", data: "evenlongerdata"),
                      ],
                    ),

                    // field view
                    Container(
                      color: Colors.blueGrey,
                      width: 623, height: 350,
                      child: Text("fled viw"),
                    ),
                  ],
                )
            
              ],
            ),
          ),
        )
    );
  }
}


class LabelContainer extends StatelessWidget {

  final String label;
  final String data;

  const LabelContainer({required this.label, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      width: 200, height: 200,
      alignment: .center,
      padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(flex: 1, child: Text(label, style: TextStyle(
            fontSize: 25,
            fontWeight: .bold
          ),)),
          Expanded(
            flex: 2,  
            child: Container(
              alignment: .center,
              child: Text(data)
              )
            ),
        ],
      ),
    );
  }
}