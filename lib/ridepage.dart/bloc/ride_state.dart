


import 'package:mapbox_gl/mapbox_gl.dart';

abstract class RideState {}

class RideInitial extends RideState {}


class RideRequestVisible extends RideState {
  final Map<String, dynamic> requestData;

  RideRequestVisible(this.requestData);
}

class RideRequestHidden extends RideState {}

class RideAcceptedstate extends RideState {
  final Map<String, dynamic>? rideData; 

  RideAcceptedstate({this.rideData});
}

  class RideLoadingState extends RideState{}


class RideOnlineState extends RideState {
  final bool isOnline;
  RideOnlineState(this.isOnline);
}





class RideStartedState extends RideState {
  final String otp;

  RideStartedState(this.otp);
}

class RideCompletedState extends RideState {

  RideCompletedState();
}

class RideErrorState extends RideState {
  final String message;

  RideErrorState(this.message);
}




class PicupSimulationState extends RideState{
  final LatLng currentlocation;
  final LatLng picuplocation;

  PicupSimulationState({required this.currentlocation, required this.picuplocation});
}

class PicupCompletedState extends RideState{}

class ReachedButtonEnabledState extends RideState {}


class DropSimulationState extends RideState{}




class ButtonVisibleState extends RideState {}



class RideCancelledState extends RideState{}