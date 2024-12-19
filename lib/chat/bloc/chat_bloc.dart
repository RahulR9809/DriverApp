

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:employerapp/controller/chat_controller.dart';
import 'package:employerapp/main.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService; // Injected ChatService instance
  List<String> _messages = []; // List to hold chat messages

  ChatBloc({required this.chatService}) : super(ChatInitial()) {
    // Event handlers
    on<ChatSocketConnectedevent>(_onChatConnected);
    on<ChatSocketDisconnectedevent>(_onChatDisconnected);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadMessages>(_onLoadMessages);
  }

  // Fetch the userId from SharedPreferences
  Future<String?> _getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userid');
  }
Future<String?> _getTripId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('tripid');
  }

  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('login_id');
  }
  // Connect to chat socket
  // FutureOr<void> _onChatConnected(
  //     ChatSocketConnectedevent event, Emitter<ChatState> emit) {
  //   driverSocketChatService.connect(event.driverId);
  //     _initializeSocketListeners();

  //   emit(ChatSocketConnectedstate(driverId: event.driverId));
  // }

  FutureOr<void> _onChatConnected(
    ChatSocketConnectedevent event, Emitter<ChatState> emit) {
  driverSocketChatService.connect(event.driverId);

  // Listen for incoming messages and dispatch MessageReceived events
  driverSocketChatService.listenForMessages((message) {
    add(MessageReceived( message));
  });

  emit(ChatSocketConnectedstate(driverId: event.driverId));
}


  // Disconnect from chat socket
  FutureOr<void> _onChatDisconnected(
      ChatSocketDisconnectedevent event, Emitter<ChatState> emit) {
    driverSocketChatService.disconnect();
    emit(ChatSocketDisconnectedstate());
  }


FutureOr<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('accesstoken');
    final userId = await _getUserId();
    final tripId = await _getTripId();
    final driverid=await _getDriverId();
    if (token != null && userId != null && tripId != null) {
      if (kDebugMode) {
        print("Sending message: ${event.message}, Token: $token");
      }
      await chatService.sendMessage(
        senderId: driverid!,
         recieverId: userId,
          message: event.message,
           tripId: tripId,
            senderType: 'driver',
             driverId: driverid,
              userId: userId);

      _messages.add(event.message);
      emit(ChatMessagesLoaded(messages: _messages));
      print("Message sent and state updated");
    } else {
      print("Required data is missing");
      emit(ChatError(message: 'Required data (token, userId, tripId) is missing'));
    }
  } catch (e) {
    print("Error in SendMessage: $e");
    emit(ChatError(message: 'Failed to send message: $e'));
  }
}



  // Load messages from API
  FutureOr<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    try {
      List<dynamic> messages = await chatService.getMessages(
        token: event.token,
        tripId: event.tripId,
      );

      _messages = messages.map((e) => e.toString()).toList();
      print(_messages);
      emit(ChatMessagesLoaded(messages: _messages));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }

  // Handle incoming messages via socket
FutureOr<void> _onMessageReceived(
    MessageReceived event, Emitter<ChatState> emit) {
  _messages.add(event.message);
  print(_messages);
  emit(ChatMessagesLoaded(messages: List.from(_messages))); // Emit updated messages
}




void _initializeSocketListeners() {
  // Listen for incoming messages via socket
  driverSocketChatService.listenForMessages((message) {
    if (kDebugMode) {
      print('New message received via socket: $message');
    }
    add(MessageReceived( message));
  });
}
  
}
