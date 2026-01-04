import 'package:driver_dashboard/ntcore/instance.dart';
import 'package:driver_dashboard/ntcore/ntcore_structs.dart';
import 'package:driver_dashboard/ntreferences.dart';
import 'package:driver_dashboard/util.dart';
import 'package:driver_dashboard/ntcore/values.dart';
import "package:driver_dashboard/widgets/pid_container.dart";
import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              spacing: 20,
              children: [
                const Expanded(child: PIDContainer(title: "Subsystem!!!!!")),
                const Expanded(child: PIDContainer(title: "Cooler Subsystem B)")),
              ]
            ),
          ),

          VerticalDivider(),

          Expanded(
            flex: 1,
            child: NTPrefixDisplay()
          ),

          VerticalDivider(),
          
          Expanded(
            flex: 3,
            child: const Placeholder()
          )
        ],
      ),
    );
  }
}

// TODO: change to show all data values in a prefix once it has bindings
// just returns a key - value pair for now
class NTPrefixData {
  bool isExpanded = false;
  final NTValueNotifier notifier;
  final String title;

  NTPrefixData({required this.notifier, required this.title,});

}

class NTPrefixDisplay extends StatelessWidget {
  NTPrefixDisplay({super.key});

  final TextStyle style = TextStyle(fontSize: 15);

  // fill up this section with any new lis
  final List<NTPrefixData> prefixes = <NTPrefixData>[
    NTPrefixData(notifier: valueNotifier, title: "Placehlolder"),
    NTPrefixData(notifier: gameTimeNotifier, title: "gameTime"),
    NTPrefixData(notifier: stateNotifier, title: "currentState"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(title: Text("NetworkTables:", style: TextStyle(fontSize: 25, fontWeight: .bold),),),
        Divider(),
        for (NTPrefixData c in prefixes)
          ListenableBuilder(
            listenable: c.notifier,
            builder: (context, _) {
              var s = switch (c.notifier.currentValue) {
                // switch statement monster, could be improved
                NTDoubleValue(:final value) => value.toString(),
                NTBooleanValue(:final value) => value.toString(),
                NTIntegerValue(:final value) => value.toString(),
                NTStringValue(:final value) => value,
                NTDoubleArrayValue(:final value) => value.toString(),
                NTBooleanArrayValue(:final value) => value.toString(),
                NTIntegerArrayValue(:final value) => value.toString(),
                NTStringArrayValue(:final value) => value.toString(),
                NTRawValue(:final value) => value.toString(), // "and coop has delivered undercooked salmon"
                _ => 'Unable to Retrieve Data',
              };
              return Text("${c.title}: $s", style: style);
            },
          ),
      ],
    );
  }

}