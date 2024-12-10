abstract class RideEvent {}

class RideRequestReceived extends RideEvent {
  final Map<String, dynamic> requestData;

  RideRequestReceived(this.requestData);
}

class RideAccepted extends RideEvent {}

class RideRejected extends RideEvent {}

