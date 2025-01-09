

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

    socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
       'path': '/socket.io/',
      'transports': ['websocket'],
      'autoConnect': true,
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


  // cancel-ride

  // Close the socket connection
  // void disconnect() {
  //   socket.disconnect();
  // }
  

  // Method to check if there are any ride requests available
Future<Map<String, dynamic>?> checkRideRequests() async {
  try {
    // Use a Completer to handle the response asynchronously
    final Completer<Map<String, dynamic>?> completer = Completer();

    // // Emit a request to check for ride requests
    // socket.emit('check-ride-requests', null);

    // Listen for the server's response
    socket.once('ride-requests-response', (data) {
      if (kDebugMode) {
        print('Ride requests response: $data');
      }
      completer.complete(data as Map<String, dynamic>?); // Resolve the completer with the response
    });

    // Return the response or null if none is received within a timeout
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        if (kDebugMode) {
          print('Timeout while waiting for ride request response.');
        }
        return null;
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error in checkRideRequests: $e');
    }
    return null;
  }
}

}


