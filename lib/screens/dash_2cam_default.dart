import 'package:driver_dashboard/ntcore/values.dart';
import 'package:driver_dashboard/ntreferences.dart';
import 'package:mjpeg_view/mjpeg_view.dart';
import 'package:driver_dashboard/util.dart';
import 'package:flutter/material.dart';

class Default2CamDashboard extends StatefulWidget {
  const Default2CamDashboard({super.key});

  @override
  State<Default2CamDashboard> createState() => _Default2CamDashboardState();
}

class _Default2CamDashboardState extends State<Default2CamDashboard> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        Container(
          width: 640,
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 45.0, 0.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                theme.colorScheme.primaryContainer,
                theme.scaffoldBackgroundColor,
              ],
              stops: [0.8, 1.0],
            ),
          ),
          child: Column(
            spacing: 30,
            mainAxisAlignment: .center,
            children: [
              // limelight cameras are 4:3 aspect ratio
              SizedBox(
                width: 640,
                height: 480,
                child: MjpegView(
                  errorWidget: cameraErrorWidget,
                  uri:
                      'http://61.211.241.239/nphMotionJpeg?Resolution=320x240&Quality=Standard',
                ),
              ),

              SizedBox(
                width: 640,
                height: 480,
                child: MjpegView(
                  errorWidget: cameraErrorWidget,
                  uri:
                      llCamUrls[1] ??
                      'http://webcam01.ecn.purdue.edu/mjpg/video.mjpg',
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(45.0, 0.0, 15.0, 0.0),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              spacing: 30,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: .centerLeft,
                      child: Text(
                        'Match 1',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    Align(
                      alignment: .center,
                      child: Text('-:--', style: theme.textTheme.displayLarge),
                    ),
                    Align(
                      alignment: .centerRight,
                      child: Text(
                        'Blue Alliance',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                // field view
                Image(
                  // width: 623,
                  // height: 350,
                  image: AssetImage('images/2025-field.png'),
                ),

                // icons
                Row(
                  mainAxisAlignment: .center,
                  spacing: 10.0,
                  crossAxisAlignment: .center,
                  children: [
                    Icon(Icons.control_camera, color: Colors.green),
                    Icon(Icons.two_wheeler, color: Colors.green),
                    Icon(Icons.battery_0_bar, color: Colors.red),
                  ],
                ),

                Row(
                  mainAxisAlignment: .spaceEvenly,
                  crossAxisAlignment: .center,
                  spacing: 5.0,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text('A: do X'),
                        Text('B: do X'),
                        Text('X: do X'),
                        Text('Y: do X'),
                        Text('LT: do X'),
                        Text('LB: do X'),
                        Text('RT: do X'),
                        Text('RB: do X'),
                        Text('Swerve enabled'),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      spacing: 5.0,
                      children: [
                        Text('Current Auto:'),
                        DropdownButton(
                          items: [
                            DropdownMenuItem(
                              value: 'SomeAuto',
                              child: Text('SomeAuto'),
                            ),
                          ],
                          onChanged: (val) {},
                          value: 'SomeAuto',
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: .spaceEvenly,
                      mainAxisSize: .max,
                      crossAxisAlignment: .end,
                      children: [
                        Text('Coral in bot: No'),
                        Text('Some thing from NT: idk'),
                        Container(
                          color: Colors.redAccent,
                          child: Text(
                            'You can do containers or whatever here idc',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          spacing: 10,
                          children: [
                            FloatingActionButton.small(
                              onPressed: () {},
                              child: Text('-'),
                            ),
                            Text('Incrementable Counter: 2'),
                            FloatingActionButton.small(
                              onPressed: () {},
                              child: Text('+'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
