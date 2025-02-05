import 'package:employerapp/repository/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverSocketChatService {
  static final DriverSocketChatService _instance =
      DriverSocketChatService._internal();
  late IO.Socket socket;
  Function(Map<String, dynamic>)? onMessageReceivedCallback;

  factory DriverSocketChatService() {
    return _instance;
  }

  DriverSocketChatService._internal();

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

    socket.onConnect((_) {
      if (kDebugMode) {
        print('Chat socket connected to server');
      }
    });

    socket.onConnectError((error) {
      if (kDebugMode) {
        print(' chat Connection error: $error');
      }
    });

    socket.on('latestMessage', (data) {
      if (kDebugMode) {
        print('message from socketadasda:$data');
      }
      if (data != null && onMessageReceivedCallback != null) {
        onMessageReceivedCallback!(data);
      }
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from server');
      }
    });
  }

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

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  // ignore: unused_element
  void _handleIncomingMessage(dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      final String message = data['message'] ?? '';
      final String senderId = data['senderId'] ?? '';
      if (kDebugMode) {
        print('Message from $senderId: $message');
      }
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
