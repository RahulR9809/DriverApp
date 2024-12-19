
// import 'package:mapbox_gl/mapbox_gl.dart';

// abstract class RideEvent {}

// class ToggleOnlineStatus extends RideEvent {
//   final bool isOnline;

//   ToggleOnlineStatus(this.isOnline);
// }

// class RideRequestReceived extends RideEvent {
//   final Map<String, dynamic> requestData;

//   RideRequestReceived(this.requestData);
// }

// class RideAccepted extends RideEvent {}

// class RideRejected extends RideEvent {}



// class ChatSocketConnectedevent extends RideEvent{
// final String driverId;

//   ChatSocketConnectedevent({required this.driverId});
// }

// class ChatSocketDisconnectedevent extends RideEvent{}




import 'package:mapbox_gl/mapbox_gl.dart';

abstract class RideEvent {}

class ToggleOnlineStatus extends RideEvent {
  final bool isOnline;

  ToggleOnlineStatus(this.isOnline);
}


class RideAccepted extends RideEvent {}

class RideRequestReceived extends RideEvent {
  final Map<String, dynamic> requestData;

  RideRequestReceived(this.requestData);
}

class RideAcceptedEvent extends RideEvent {
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;

  RideAcceptedEvent({
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
  });
}



class ResumeSimulationEvent extends RideEvent {
  final double endLatitude;
  final double endLongitude;
  ResumeSimulationEvent({
    required this.endLatitude,
    required this.endLongitude,
  });
}


class RideRejected extends RideEvent {}



// class ChatSocketConnectedevent extends RideEvent{
// final String driverId;

//   ChatSocketConnectedevent({required this.driverId});
// }

// class ChatSocketDisconnectedevent extends RideEvent{}

