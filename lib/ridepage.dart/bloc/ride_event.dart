




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



class RideCancelledEvent extends RideEvent{
  final Map<String, dynamic> rideCancelleddata;

  RideCancelledEvent({required this.rideCancelleddata});

}








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
