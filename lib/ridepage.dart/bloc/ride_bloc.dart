import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/controller/ride_controller.dart';
import 'package:employerapp/controller/socket_controller.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

DriverSocketChatService driverSocketChatService = DriverSocketChatService();
bool _isOnline = false; // Keep track of online/offline status


List<dynamic>? picuplocationRaw;
List<dynamic>? droplocationRaw;
   Map<String, dynamic>? cancelsdata;

class RideBloc extends Bloc<RideEvent, RideState> {
  final DriverSocketService socketService;
  final RideController rideController;
  bool _isOnline = false; // Track online/offline status
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
    _isOnline = event.isOnline; // Update internal state

    if (_isOnline) {
      try {      
        socketService.connect((data) => add(RideRequestReceived(data)));
      } catch (e) {
        print("Error connecting: $e");
      }
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

        if (currentRequest.isEmpty) {
          print('Error: currentRequest is null');
          return;
        }
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];

        final userid = currentRequest['userId'];
                print('user id: $userid');
                print('trip id: $tripId');

// final startCoordinates = LatLng( 9.93213798131877,76.31803168453493);
//         final picuplocation = currentRequest['startLocation']?['coordinates'];

        final startCoordinates = LatLng(9.93213798131877, 76.31803168453493);
        final picuplocationRaw =currentRequest['startLocation']?['coordinates'];
        final droplocationRaw = currentRequest['endLocation']?['coordinates'];

        print('dropcoordinates:$droplocationRaw');
        print('picupcoordinates:$picuplocationRaw');
        if (picuplocationRaw == null || picuplocationRaw.length < 2) {
          print('Error: Coordinates are invalid');
          return;
        }

// Convert to LatLng
        final picuplocation = LatLng(picuplocationRaw[0], picuplocationRaw[1]);

        print('start:$startCoordinates');
        print('picuplocation:$picuplocation');

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('userid', userid);
        // pref.setString('tripid', tripId);
                pref.setString('tripid', tripId);

        if (driverId != null && tripId != null) {
          final res = await rideController.acceptRide(
            driverId: driverId,
            status: 'accepted',
            tripId: tripId,
          );
          if (res.isNotEmpty) {
            emit(RideAcceptedstate(rideData: currentRequest));
            // await Future.delayed(const Duration(seconds: 4));
            print(
                'Emitting PicupSimulationState with start: $startCoordinates, end: $picuplocation');

DriverSocketChatService driverSocketChatService=DriverSocketChatService();
driverSocketChatService.connect(tripId);
print('driver chat connected');

            emit(PicupSimulationState(
                currentlocation: startCoordinates,
                picuplocation: picuplocation));
            await Future.delayed(const Duration(seconds: 60));
 previousState = state;
            print('emitting reached button');
            emit(ReachedButtonEnabledState());
          }
        }
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

    emit(RideOnlineState(_isOnline));
  }

  Future<void> _onStartRide(
      StartRideEvent event, Emitter<RideState> emit) async {

      //    if (state is RideAcceptedstate) {
      // // Access rideData from the RideAcceptedstate
      // final rideData = (state as RideAcceptedstate).rideData;

    

    try {
      final tripid = await getTripid();
      print('this is tripid:$tripid');
   await rideController.startRide(
        tripOtp: event.tripOtp,
        tripId: tripid!,
      );

   print('emiting ridestart state');
      emit(RideStartedState(event.tripOtp));
      print(event.tripOtp);
        //  final picuplocation = LatLng(picuplocationRaw?[0], picuplocationRaw?[1]);
        //  final droplocation = LatLng(picuplocationRaw?[0], picuplocationRaw?[1]);

  //  print('picuplocation:$picuplocation');
  //  print('Droplocation:$droplocation');
   
      // print('emiting dropsimulation state');
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
      print('usesrid:$userid');
      print('tripid:$tripid');
      await rideController.completeRide(
        tripId: tripid!,
        userId: userid!,
      );
      emit(RideCompletedState());
    } catch (e) {
      print('Error completing ride: $e');
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
cancelsdata=event.rideCancelleddata;
if(cancelsdata !=null){
  print('emitting cancelled state');
emit(RideCancelledState());

}
  }
}
