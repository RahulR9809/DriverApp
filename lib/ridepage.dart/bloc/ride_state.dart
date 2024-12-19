
// import 'package:mapbox_gl/mapbox_gl.dart';

// abstract class RideState {}

// class RideInitial extends RideState {}


// class RideRequestVisible extends RideState {
//   final Map<String, dynamic> requestData;

//   RideRequestVisible(this.requestData);
// }

// class RideRequestHidden extends RideState {}

// class RideAcceptedstate extends RideState {
//   final Map<String, dynamic>? rideData; // Include ride data

//   RideAcceptedstate({this.rideData});
// }

//   class RideLoadingState extends RideState{}


// //   class ChatSocketConnectedstate extends RideState{
// // final String driverId;

// //   ChatSocketConnectedstate({required this.driverId});
// // }

// // class ChatSocketDisconnectedstate extends RideState{}


// class RideOnlineState extends RideState {
//   final bool isOnline;
//   RideOnlineState(this.isOnline);
// }

// class RideAnimationState extends RideState {
//   final LatLng vehiclePosition;
//   final List<LatLng> remainingRoute;
//   RideAnimationState({
//     required this.vehiclePosition,
//     required this.remainingRoute,
//   });
// }




import 'package:mapbox_gl/mapbox_gl.dart';

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


//   class ChatSocketConnectedstate extends RideState{
// final String driverId;

//   ChatSocketConnectedstate({required this.driverId});
// }

// class ChatSocketDisconnectedstate extends RideState{}


class RideOnlineState extends RideState {
  final bool isOnline;
  RideOnlineState(this.isOnline);
}


class RideSimulationInProgress extends RideState {
  final double currentLatitude;
  final double currentLongitude;
  final double endLatitude;
  final double endLongitude;

  RideSimulationInProgress({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}

class RideSimulationCompleted extends RideState {}

class RideSimulationResumed extends RideState {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  RideSimulationResumed({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}
