
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


  RideAcceptedEvent();
}


class RideRejected extends RideEvent {}












class StartRideEvent extends RideEvent {
  final String tripOtp;
  final String? tripId;

  StartRideEvent({
    required this.tripOtp,
     this.tripId,
  });
}

class CompleteRideEvent extends RideEvent {
  final String? tripId;
  final String? userId;

  CompleteRideEvent({
     this.tripId,
     this.userId,
  });
}



class PicupSimulationEvent extends RideEvent{}





class AnimationCompleted extends RideEvent {}
