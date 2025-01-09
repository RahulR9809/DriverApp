

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:employerapp/chat/chat_page.dart';
import 'package:employerapp/controller/chat_controller.dart';
import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/main.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';


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
ChatService chatService = ChatService();
final DriverSocketChatService _socketService = DriverSocketChatService();

  List<String> _messages = []; // List to hold chat messages
List<Map<String, dynamic>> _sentMessages = [];  // Store sent messages
List<Map<String, dynamic>> _receivedMessages = [];

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadMessages>(_onLoadMessages);

    _socketService.setOnMessageReceivedCallback((data) {
      final message = data['message'] ?? '';
      final senderId = data['senderId'] ?? '';

      if (message.isNotEmpty) {
        add(MessageReceived(message, senderId));
      }
    });
  }

  FutureOr<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();
    String? driverId = await _getDriverId();
    String? tripId = await _getTripId();

    if (userId != null && driverId != null && tripId != null) {
      chatService.sendMessage(
        senderId: driverId,
        recieverId: userId,
        message: event.message,
        tripId: tripId,
        senderType: 'driver',
        driverId: driverId,
        userId: userId,
      );

      // Add the sent message immediately without triggering full rebuild
      _sentMessages.add({
        'message': event.message,
        'isSender': true,
      });

      // Only emit updated sent messages to avoid full UI rebuild
      emit(ChatSentMessagesUpdated(messages: _sentMessages));
    } else {
      emit(ChatError(message: 'User ID not found'));
    }
  }


  FutureOr<void> _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) async {
    String? driverId = await _getDriverId();

    // Add the received message
    _receivedMessages.add({
      'message': event.message,
      'isSender': event.senderid == driverId,
    });

    // Emit the updated state with received messages
    emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
  }

  FutureOr<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('accesstoken');
      final tripId = await _getTripId();

      List<dynamic> messages = await chatService.getMessages(
        token: token ?? 'get message token not found',
        tripId: tripId ?? 'get message tripid not found',
      );

      String? driverId = await _getDriverId();

      _receivedMessages = messages.map((e) {
        return {
          'message': e['message'],
          'isSender': e['senderId'] == driverId,
        };
      }).toList();

      emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }
}
