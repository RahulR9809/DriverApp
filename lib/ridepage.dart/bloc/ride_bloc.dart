import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/controller/ride_controller.dart';
import 'package:employerapp/controller/socket_controller.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
DriverSocketChatService driverSocketChatService=DriverSocketChatService();
  bool _isOnline = false; // Keep track of online/offline status

// class RideBloc extends Bloc<RideEvent, RideState> {
//   final DriverSocketService socketService;
//   final RideController rideController;

//   RideBloc(this.rideController, {required this.socketService})
//       : super(RideInitial()) {
//     // Register event handlers
//     on<RideRequestReceived>(_onRideRequestReceived);
//     on<RideAccepted>(_onRideAccepted);
//     on<RideRejected>(_onRideRejected);
//     on<ChatSocketConnectedevent>(_onChatConnected);
//     on<ChatSocketDisconnectedevent>(_onchatDisconnected);
//     on<ToggleOnlineStatus>(_onToggleOnlineStatus);

//   }

//   // Event handler for RideRequestReceived
//   void _onRideRequestReceived(
//       RideRequestReceived event, Emitter<RideState> emit) {
//     emit(RideRequestVisible(event.requestData));
//   }

//   // Event handler for RideAccepted
//   Future<void> _onRideAccepted(
//       RideAccepted event, Emitter<RideState> emit) async {

//     try {
//       if (state is RideRequestVisible) {
//         final currentRequest = (state as RideRequestVisible).requestData;
//         final driverId = await _getDriverId();
//         final tripId = currentRequest['_id'];
//         final userLat = currentRequest['startLocation']['coordinates'][0];
//         final userLong = currentRequest['startLocation']['coordinates'][1];

//         // Store latitude and longitude in SharedPreferences
//         SharedPreferences rideLocation = await SharedPreferences.getInstance();
//         await rideLocation.setString('userlat', userLat.toString());
//         await rideLocation.setString('userlong', userLong.toString());

//         if (driverId != null && tripId != null) {
//           final data= rideController.acceptRide(
//               driverId: driverId, status: 'Accepted', tripId: tripId);
//               if (kDebugMode) {
//                 print('accepted data is here bruh$data');
//               }
//         }
// emit(RideAcceptedstate(rideData: currentRequest));
       
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error Accepting ride: $e');
//       }
//     }
//     emit(RideRequestHidden());
//   }

//   // Event handler for RideRejected
//   Future<void> _onRideRejected(
//       RideRejected event, Emitter<RideState> emit) async {
//     try {
//       if (state is RideRequestVisible) {
//         final currentRequest = (state as RideRequestVisible).requestData;
//         final driverId = await _getDriverId();
//         final tripId = currentRequest['_id'];

//         if (driverId != null && tripId != null) {
//           await rideController.rejectRide(
//               driverId: driverId, status: 'Rejected', tripId: tripId);
//           if (kDebugMode) {
//             print('Ride rejected successfully');
//           }
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error rejecting ride: $e');
//       }
//     } finally {
//       emit(RideRequestHidden());
//     }
//   }

//   // Helper function to get driver ID from SharedPreferences
//   Future<String?> _getDriverId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('login_id');
//   }

//   @override
//   Future<void> close() {
//     // socketService.disconnect();
//     return super.close();
//   }

//   // This method connects to the socket when needed
//   void connectSocket(BuildContext context) {
//     socketService.connect( (data) => add(RideRequestReceived(data)));
//   }

//   FutureOr<void> _onChatConnected(ChatSocketConnectedevent event, Emitter<RideState> emit) {
//         driverSocketChatService.connect(event.driverId);
//     emit(ChatSocketConnectedstate(driverId: event.driverId));
//   }

//   FutureOr<void> _onchatDisconnected(ChatSocketDisconnectedevent event, Emitter<RideState> emit) {
//     driverSocketChatService.disconnect();
//     emit(ChatSocketDisconnectedstate());
//   }


//   Future<void> _onToggleOnlineStatus(
//     ToggleOnlineStatus event, Emitter<RideState> emit) async {
//   if (event.isOnline) {
//     // Connect to location and socket when online
//     try {
//       final driverId = await _getDriverId();
//       driverSocketChatService.connect(driverId!);
//       socketService.connect( (data) => add(RideRequestReceived(data)));
//       emit(RideOnlineState(true));
//     } catch (e) {
//       print("Error connecting: $e");
//     }
//   } else {
//     // Disconnect socket and emit offline state
//     driverSocketChatService.disconnect();
//     socketService.disconnect();
//     emit(RideOnlineState(false));
//   }
// }
// }


















class RideBloc extends Bloc<RideEvent, RideState> {
  final DriverSocketService socketService;
  final RideController rideController;

  bool _isOnline = false; // Track online/offline status

  RideBloc(this.rideController, {required this.socketService})
      : super(RideInitial()) {
    on<RideRequestReceived>(_onRideRequestReceived);
    on<RideAcceptedEvent>(_onRideAccepted);
    on<RideRejected>(_onRideRejected);
    // on<ChatSocketConnectedevent>(_onChatConnected);
    // on<ChatSocketDisconnectedevent>(_onChatDisconnected);
    on<ToggleOnlineStatus>(_onToggleOnlineStatus);

    on<ResumeSimulationEvent>(_onResumeSimulation);
  }

  Future<void> _onToggleOnlineStatus(
      ToggleOnlineStatus event, Emitter<RideState> emit) async {
    _isOnline = event.isOnline; // Update internal state

    if (_isOnline) {
      try {
        final driverId = await _getDriverId();
        driverSocketChatService.connect(driverId!);
        socketService.connect((data) => add(RideRequestReceived(data)));
      } catch (e) {
        print("Error connecting: $e");
      }
    } else {
      driverSocketChatService.disconnect();
      socketService.disconnect();
    }

    emit(RideOnlineState(_isOnline)); // Emit the updated state
  }

  void _onRideRequestReceived(
      RideRequestReceived event, Emitter<RideState> emit) {
    emit(RideRequestVisible(event.requestData));
  }

 Future<void> _onRideAccepted(
      RideAcceptedEvent event, Emitter<RideState> emit) async {
    try {
      if (state is RideRequestVisible) {
        final currentRequest = (state as RideRequestVisible).requestData;

        if (currentRequest == null) {
          print('Error: currentRequest is null');
          return;
        }

        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];
        
        final userid = currentRequest['userId'];
final startCoordinates = LatLng( 9.93213798131877,76.31803168453493); // Mapbox LatLng
        final picuplocation = currentRequest['startLocation']?['coordinates'];

        if (
            picuplocation == null || picuplocation.length < 2) {
          print('Error: Coordinates are invalid');
          return;
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('userid', userid);
      pref.setString('tripid', tripId);
        if (driverId != null && tripId != null) {
          await rideController.acceptRide(
            driverId: driverId,
            status: 'Accepted',
            tripId: tripId,
          );
        }

        emit(RideAcceptedstate(rideData: currentRequest));

        // Update coordinates and emit RideSimulationInProgress
        _currentLatitude = startCoordinates.latitude; // Latitude
        _currentLongitude = startCoordinates.longitude; // Longitude

        emit(RideSimulationInProgress(
          currentLatitude: _currentLatitude,
          currentLongitude: _currentLongitude,
          endLatitude: picuplocation[0], // Latitude
          endLongitude: picuplocation[1], // Longitude
        ));

        print(
            'State emitted: RideSimulationInProgress with coordinates: $_currentLatitude, $_currentLongitude -> ${picuplocation[1]}, ${picuplocation[0]}');
      }
    } catch (e) {
      print('Error Accepting ride: $e');
    }
  }



  Future<void> _onRideRejected(
      RideRejected event, Emitter<RideState> emit) async {
    try {
      if (state is RideRequestVisible) {
        final currentRequest = (state as RideRequestVisible).requestData;
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];
        print('it is from ride:$tripId');
    SharedPreferences pref = await SharedPreferences.getInstance();
pref.setString('tripid', tripId);
        if (driverId != null && tripId != null) {
          await rideController.rejectRide(
              driverId: driverId, status: 'Rejected', tripId: tripId);
        }
      }
    } catch (e) {
      print('Error rejecting ride: $e');
    }

    emit(RideOnlineState(_isOnline)); // Keep the state consistent
  }

  
  // FutureOr<void> _onChatConnected(ChatSocketConnectedevent event, Emitter<RideState> emit) {
  //       driverSocketChatService.connect(event.driverId);
  //   emit(ChatSocketConnectedstate(driverId: event.driverId));
  // }

  // FutureOr<void> _onChatDisconnected(ChatSocketDisconnectedevent event, Emitter<RideState> emit) {
  //   driverSocketChatService.disconnect();
  //   emit(ChatSocketDisconnectedstate());
  // }




    double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;



  Future<void> _onResumeSimulation(
    ResumeSimulationEvent event,
    Emitter<RideState> emit,
  ) async {
    // Resume simulation with the new end coordinates
    emit(RideSimulationResumed(
      startLatitude: _currentLatitude,
      startLongitude: _currentLongitude,
      endLatitude: event.endLatitude,
      endLongitude: event.endLongitude,
    ));
  }


  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('login_id');
  }

  @override
  Future<void> close() {
    return super.close();
  }
}


