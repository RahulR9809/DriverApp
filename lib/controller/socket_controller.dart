

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'auth_controller.dart';

class DriverSocketService {
  late IO.Socket socket;
  Function(Map<String, dynamic>)? onTripcancelledCallback;

  // Method to retrieve the driver ID from SharedPreferences
  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? driverId = pref.getString('login_id');
    return driverId;
  }

  // Connect the driver app to the server and listen for events
  Future<void> connect( Function(Map<String, dynamic>)onRideRequestReceived) async {
    String? driverId = await _getDriverId();

    if (driverId == null) {
      if (kDebugMode) {
        print('Cannot connect without a valid driver ID');
      }
      return;
    }

    socket = IO.io('http://$ipConfig:3003', <String, dynamic>{
       'path': '/socket.io/trip',
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      if (kDebugMode) {
        print('Driver connected successfully: $driverId');
      }
      socket.emit('driver-connected', driverId); // Emit the driver ID to the server
    });

    socket.onConnectError((error) {
      if (kDebugMode) {
        print("Connection error: $error");
      }
    });

    socket.onError((error) {
      if (kDebugMode) {
        print("Socket error: $error");
      }
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Driver disconnected from the server');
      }
    });

    socket.onReconnect((attempt) {
      if (kDebugMode) {
        print('Reconnection attempt: $attempt');
      }
    });

    // Listen for ride requests from the server and call the callback function
    socket.on('ride-request', (data) {
      if (kDebugMode) {
        print('Received ride request: $data');
      }
      onRideRequestReceived(data);  // Pass the data to the callback in Ridepage
    });



        socket.on('cancel-ride', (data) {
      print('message from cancelSocket:$data');
      if (data != null && onTripcancelledCallback != null) {
        onTripcancelledCallback!(data);
      }
    });

  }


}


