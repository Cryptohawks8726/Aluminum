import 'package:driver_dashboard/ntcore/instance.dart';
import 'package:driver_dashboard/ntcore/values.dart';

/* 
update port number and server name for irl testing
localhost:5810 can be used for testing w/ robot sim (unless you're on mac ;-;)
  */
final NTInstance inst = NTInstance()..updateServerNamePort("localhost", 5810);

final NTValueNotifier gameTimeNotifier = NTValueNotifier.fromName(
  valueName: "/SmartDashboard/gameTime",
  inst: inst,
);
final NTValueNotifier stateNotifier = NTValueNotifier.fromName(
  valueName: "/SmartDashboard/currentState",
  inst: inst,
);