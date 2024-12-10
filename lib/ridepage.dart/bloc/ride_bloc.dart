import 'package:employerapp/controller/ride_controller.dart';
import 'package:employerapp/controller/socket_controller.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final DriverSocketService socketService;
  final RideController rideController;

  RideBloc(this.rideController, {required this.socketService})
      : super(RideInitial()) {
    // Register event handlers
    on<RideRequestReceived>(_onRideRequestReceived);
    on<RideAccepted>(_onRideAccepted);
    on<RideRejected>(_onRideRejected);
  }

  // Event handler for RideRequestReceived
  void _onRideRequestReceived(
      RideRequestReceived event, Emitter<RideState> emit) {
    emit(RideRequestVisible(event.requestData));
  }

  // Event handler for RideAccepted
  Future<void> _onRideAccepted(
      RideAccepted event, Emitter<RideState> emit) async {

    try {
      if (state is RideRequestVisible) {
        final currentRequest = (state as RideRequestVisible).requestData;
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];
        final userLat = currentRequest['startLocation']['coordinates'][0];
        final userLong = currentRequest['startLocation']['coordinates'][1];

        // Store latitude and longitude in SharedPreferences
        SharedPreferences rideLocation = await SharedPreferences.getInstance();
        await rideLocation.setString('userlat', userLat.toString());
        await rideLocation.setString('userlong', userLong.toString());

        if (driverId != null && tripId != null) {
          final data= rideController.acceptRide(
              driverId: driverId, status: 'Accepted', tripId: tripId);
              print('accepted data is here bruh$data');
        }
emit(RideAcceptedstate(rideData: currentRequest));
       
      }
    } catch (e) {
      print('Error Accepting ride: $e');
    }
    emit(RideRequestHidden());
  }

  // Event handler for RideRejected
  Future<void> _onRideRejected(
      RideRejected event, Emitter<RideState> emit) async {
    try {
      if (state is RideRequestVisible) {
        final currentRequest = (state as RideRequestVisible).requestData;
        final driverId = await _getDriverId();
        final tripId = currentRequest['_id'];

        if (driverId != null && tripId != null) {
          await rideController.rejectRide(
              driverId: driverId, status: 'Rejected', tripId: tripId);
          print('Ride rejected successfully');
        }
      }
    } catch (e) {
      print('Error rejecting ride: $e');
    } finally {
      emit(RideRequestHidden());
    }
  }

  // Helper function to get driver ID from SharedPreferences
  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('login_id');
  }

  @override
  Future<void> close() {
    // socketService.disconnect();
    return super.close();
  }

  // This method connects to the socket when needed
  void connectSocket(BuildContext context) {
    socketService.connect(context, (data) => add(RideRequestReceived(data)));
  }
}
