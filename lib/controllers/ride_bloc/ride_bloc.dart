
import 'dart:async';
import 'package:employerapp/model/complete_ride_model.dart';
import 'package:employerapp/model/reject_ride.dart';
import 'package:employerapp/model/ride_accept_model.dart';
import 'package:employerapp/model/start_ride_model.dart';
import 'package:employerapp/repository/chat_socketcontroller.dart';
import 'package:employerapp/repository/ride_controller.dart';
import 'package:employerapp/repository/socket_controller.dart';
import 'package:employerapp/controllers/ride_bloc/ride_event.dart';
import 'package:employerapp/controllers/ride_bloc/ride_state.dart';

import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

DriverSocketChatService driverSocketChatService = DriverSocketChatService();


List<dynamic>? picuplocationRaw;
List<dynamic>? droplocationRaw;
    String cancelsdata='';

class RideBloc extends Bloc<RideEvent, RideState> {
  final DriverSocketService socketService;
  final RideController rideController;
  bool _isOnline = false; 
  RideState? previousState;
  static const String accessToken = 'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';

  RideBloc(this.rideController, {required this.socketService})
      : super(RideInitial()) {
    on<RideRequestReceived>(_onRideRequestReceived);
    on<RideAcceptedEvent>(_onRideAccepted);
    on<RideRejected>(_onRideRejected);
    on<ToggleOnlineStatus>(_onToggleOnlineStatus);
    on<StartRideEvent>(_onStartRide);
    on<CompleteRideEvent>(_onCompleteRide);
on<RideCancelledEvent>(rideCancelled);


  }

  Future<void> _onToggleOnlineStatus(
      ToggleOnlineStatus event, Emitter<RideState> emit) async {
    _isOnline = event.isOnline; 

    if (_isOnline) {
      try {      
        socketService.connect((data) => add(RideRequestReceived(data)));
         socketService.onTripcancelledCallback = (data) {
        add(RideCancelledEvent(rideCancelleddata: data)); 
      };
      } catch (e) {
        if (kDebugMode) {
          print("Error connecting: $e");
        }
      }
    } 
   

    emit(RideOnlineState(_isOnline));
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

        if (currentRequest.isEmpty) {
          if (kDebugMode) {
            print('Error: currentRequest is null');
          }
          return;
        }
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];

        final userid = currentRequest['userId'];
                if (kDebugMode) {
                  print('user id: $userid');
                }
                if (kDebugMode) {
                  print('trip id: $tripId');
                }


        const startCoordinates = LatLng(9.93213798131877, 76.31803168453493);
        final picuplocationRaw =currentRequest['startLocation']?['coordinates'];
        final droplocationRaw = currentRequest['endLocation']?['coordinates'];

        if (kDebugMode) {
          print('dropcoordinates:$droplocationRaw');
        }
        if (kDebugMode) {
          print('picupcoordinates:$picuplocationRaw');
        }
        if (picuplocationRaw == null || picuplocationRaw.length < 2) {
          if (kDebugMode) {
            print('Error: Coordinates are invalid');
          }
          return;
        }

        final picuplocation = LatLng(picuplocationRaw[0], picuplocationRaw[1]);

        if (kDebugMode) {
          print('start:$startCoordinates');
        }
        if (kDebugMode) {
          print('picuplocation:$picuplocation');
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('userid', userid);
                pref.setString('tripid', tripId);

        if (driverId != null && tripId != null) {
                    RideAcceptModel rideAcceptModel=RideAcceptModel(tripid: tripId, driverid: driverId, status: 'accepted');

          final res = await rideController.acceptRide(
          rideAcceptModel
          );
          if (res.isNotEmpty) {
            emit(RideAcceptedstate(rideData: currentRequest));
            if (kDebugMode) {
              print(
                'Emitting PicupSimulationState with start: $startCoordinates, end: $picuplocation');
            }

DriverSocketChatService driverSocketChatService=DriverSocketChatService();
driverSocketChatService.connect(tripId);
if (kDebugMode) {
  print('driver chat connected');
}

            emit(PicupSimulationState(
                currentlocation: startCoordinates,
                picuplocation: picuplocation));
            await Future.delayed(const Duration(seconds: 60));
 previousState = state;
            if (kDebugMode) {
              print('emitting reached button');
            }
            emit(ReachedButtonEnabledState());
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error Accepting ride: $e');
      }
    }
  }

  Future<void> _onRideRejected(
      RideRejected event, Emitter<RideState> emit) async {
    try {
      if (state is RideRequestVisible) {
        final currentRequest = (state as RideRequestVisible).requestData;
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];
        if (kDebugMode) {
          print('it is from ride:$tripId');
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('tripid', tripId);
        if (driverId != null && tripId != null) {
          RejectRideModel rejectRideModel=RejectRideModel(driverId: driverId, status: 'Rejected', tripId: tripId);
          await rideController.rejectRide(
rejectRideModel);        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error rejecting ride: $e');
      }
    }

    emit(RideOnlineState(_isOnline));
  }

  Future<void> _onStartRide(
      StartRideEvent event, Emitter<RideState> emit) async {
    try {
      final tripid = await getTripid();
      if (kDebugMode) {
        print('this is tripid:$tripid');
      }
      StartRideModel startRideModel=StartRideModel(tripOtp: event.tripOtp, tripId: tripid!);
   await rideController.startRide(
       startRideModel
      );

   if (kDebugMode) {
     print('emiting ridestart state');
   }
      emit(RideStartedState(event.tripOtp));
      if (kDebugMode) {
        print(event.tripOtp);
      }

      emit(DropSimulationState());
    } catch (e) {
      emit(RideErrorState('Failed to start ride.'));
    }
  }



  Future<void> _onCompleteRide(
      CompleteRideEvent event, Emitter<RideState> emit) async {
    try {
      final tripid = await getTripid();
      final userid = await getUser();
      if (kDebugMode) {
        print('usesrid:$userid');
      }
      if (kDebugMode) {
        print('tripid:$tripid');
      }
      CompleteRideModel completeRideModel=CompleteRideModel(tripId: tripid!, userId: userid!);
      await rideController.completeRide(
       completeRideModel
      );
      emit(RideCompletedState());
    } catch (e) {
      if (kDebugMode) {
        print('Error completing ride: $e');
      }
      emit(RideErrorState('Failed to complete ride.'));
    }
  }



  Future<String?> getTripid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final tripid = pref.getString('tripid');
    return tripid;
  }

  Future<String?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userid = pref.getString('userid');
    return userid;
  }

  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('login_id');
  }

 





FutureOr<void> rideCancelled(RideCancelledEvent event, Emitter<RideState> emit) {
  cancelsdata = event.rideCancelleddata;

  // ignore: unnecessary_null_comparison
  if (cancelsdata != null) {
    if (kDebugMode) {
      print('emitting cancelled state with data: $cancelsdata');
    }
    emit(RideCancelledState(cancelsdata));
  } else {
    if (kDebugMode) {
      print('Cancellation data is null');
    }
  }
}


}


