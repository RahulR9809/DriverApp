
import 'package:employerapp/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverSocketChatService {
  static final DriverSocketChatService _instance = DriverSocketChatService._internal();
  late IO.Socket socket;
  Function(Map<String, dynamic>)? onMessageReceivedCallback;

  // Factory constructor to return the singleton instance
  factory DriverSocketChatService() {
    return _instance;
  }

  // Private constructor
  DriverSocketChatService._internal();

  // Initialize the socket
  void initializeSocket() {
    if (kDebugMode) {
      print('Initializing chat socket connection...');
    }

    socket = IO.io(
      'http://$ipConfig:3004',
      IO.OptionBuilder()
      
          .setTransports(['websocket'])
          .setPath('/socket.io/chat') 
          .disableAutoConnect()
          .build(),
    );

    // Listen for connection events
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Chat socket connected to server');
      }
    });

    // Listen for connection errors
    socket.onConnectError((error) {
      if (kDebugMode) {
        print('Connection error: $error');
      }
    });


   socket.on('latestMessage', (data) {
      print('message from socketadasda:$data');
      if (data != null && onMessageReceivedCallback != null) {
        onMessageReceivedCallback!(data);
      }
    });



    // Listen for disconnection events
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from server');
      }
    });
  }



  // Connect the socket with driverId
  void connect(String tripId) {
    if (kDebugMode) {
      print('Attempting to connect with driverId: $tripId');
    }

    socket.connect();

    socket.onConnect((_) {
      socket.emit('driver-chat-connect', tripId);
      if (kDebugMode) {
        print('Driver ID sent to server: $tripId');
      }
    });
  }

  // Disconnect the socket
  void disconnect() {
    if (kDebugMode) {
      print('Disconnecting from server...');
    }

    socket.disconnect();

    if (kDebugMode) {
      print('Driver disconnected');
    }
  }
void setOnMessageReceivedCallback(Function(Map<String, dynamic>) callback) {
    onMessageReceivedCallback = callback;
  }

  // Listen for a specific event
  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }





    void _handleIncomingMessage(dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      // Extract message and sender details
      final String message = data['message'] ?? '';
      final String senderId = data['senderId'] ?? '';
      if (kDebugMode) {
        print('Message from $senderId: $message');
      }
      // Notify the UI or BLoC about the new message
      // Use a callback, event, or state management approach to pass this message
    }
  }

  void addMessageListener(Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('latestMessage', (data) {
      if (data != null && data is Map<String, dynamic>) {
        onMessageReceived(data);
      }
    });
  }
}
