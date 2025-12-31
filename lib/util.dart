import 'package:flutter/material.dart';

String formatTime({required int timeInSeconds}) {
  return "${(timeInSeconds / 60).round()}:${timeInSeconds % 60}";
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
      width: 200,
      height: 200,
      alignment: .center,
      padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 25, fontWeight: .bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(alignment: .center, child: Text(data)),
          ),
        ],
      ),
    );
  }
}
