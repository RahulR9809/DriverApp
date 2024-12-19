

// import 'package:flutter/foundation.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class DriverSocketChatService {
//   static final DriverSocketChatService _instance = DriverSocketChatService._internal();
//   late IO.Socket socket;

//   // Factory constructor to return the singleton instance
//   factory DriverSocketChatService() {
//     return _instance;
//   }

//   // Private constructor
//   DriverSocketChatService._internal();

//   // Initialize the socket
//   void initializeSocket() {
//     if (kDebugMode) {
//       print('Initializing chat socket connection...');
//     }
//     socket = IO.io('http://10.0.2.2:3004', IO.OptionBuilder()
//       .setTransports(['websocket'])
//       .disableAutoConnect()
//       .build());

//     // Listen for connection events
//     socket.onConnect((_) {
//       if (kDebugMode) {
//         print('chat Socket connected to server');
//       }
//     });

//     // Listen for connection errors
//     socket.onConnectError((error) {
//       if (kDebugMode) {
//         print('Connection error: $error');
//       }
//     });

//     // Listen for disconnection events
//     socket.onDisconnect((_) {
//       if (kDebugMode) {
//         print('Socket disconnected from server');
//       }
//     });

//     // Handle messages from the server (optional)
//     socket.on('latestMessage', (data) {
//       if (kDebugMode) {
//         print('Received message: $data');
//       }
//     });
//   }

//   // Connect the socket with driverId
//   void connect(String driverId) {
//     if (kDebugMode) {
//       print('Attempting to connect with driverId: $driverId');
//     }
//     socket.connect();

//     socket.onConnect((_) {
//       socket.emit('driver-chat-connect', {'driverId': driverId});
//       if (kDebugMode) {
//         print('Driver ID sent to server: $driverId');
//       }
//     });
//   }

//   // Disconnect the socket
//   void disconnect() {
//     if (kDebugMode) {
//       print('Disconnecting from server...');
//     }
//     socket.disconnect();
//     if (kDebugMode) {
//       print('Driver disconnected');
//     }
//   }

//   // Send a message
//   void sendMessage(String event, Map<String, dynamic> data) {
//     socket.emit(event, data);
//   }

//   // Listen for an event
//     void on(String event, Function(dynamic) callback) {
//     socket.on(event, callback);
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverSocketChatService {
  static final DriverSocketChatService _instance = DriverSocketChatService._internal();
  late IO.Socket socket;

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
      'http://10.0.2.2:3004',
      IO.OptionBuilder()
          .setTransports(['websocket'])
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

    // Listen for disconnection events
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected from server');
      }
    });
  }

  // Listen for incoming messages
// Inside DriverSocketChatService
void listenForMessages(Function(String) onMessageReceived) {
  socket.on('latestMessage', (data) {
    if (data != null && data['message'] != null) {
      if (kDebugMode) {
        print('Message received: ${data['message']}');
      }
      onMessageReceived(data['message']);
    } else {
      if (kDebugMode) {
        print('Malformed message data: $data');
      }
    }
  });
}



  // Connect the socket with driverId
  void connect(String driverId) {
    if (kDebugMode) {
      print('Attempting to connect with driverId: $driverId');
    }

    socket.connect();

    socket.onConnect((_) {
      socket.emit('driver-chat-connect', {'driverId': driverId});
      if (kDebugMode) {
        print('Driver ID sent to server: $driverId');
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

  // Listen for a specific event
  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }
}
