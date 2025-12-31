import 'package:driver_dashboard/screens/dash_2cam_default.dart';
import 'package:flutter/material.dart';

void main() {
  // the dashboard currently does not implement the api
  // it is simply a layout
  runApp(const DriverDashboard());
}

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // TODO: add navigation buttons and stuff surrounding the main dashboard widget
        body: Container(
          padding: EdgeInsets.all(30),

          child: Default2CamDashboard(),
        ),
      ),
    );
  }
}
