abstract class RideState {}

class RideInitial extends RideState {}

class RideRequestVisible extends RideState {
  final Map<String, dynamic> requestData;

  RideRequestVisible(this.requestData);
}

class RideRequestHidden extends RideState {}

class RideAcceptedstate extends RideState {
  final Map<String, dynamic>? rideData; // Include ride data

  RideAcceptedstate({this.rideData});
}

  class RideLoadingState extends RideState{}