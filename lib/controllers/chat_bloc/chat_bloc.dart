import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:employerapp/model/chat_model.dart';
import 'package:employerapp/repository/chat_controller.dart';
import 'package:employerapp/repository/chat_socketcontroller.dart';
import 'package:flutter/foundation.dart';
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

// List<String> _messages = [];
List<Map<String, dynamic>> _sentMessages = [];
List<Map<String, dynamic>> _receivedMessages = [];

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadMessages>(_onLoadMessages);

    _socketService.setOnMessageReceivedCallback((data) {
      final message = data['message'] ?? '';
      final senderId = data['senderId'] ?? '';
      final time = _formatTime(DateTime.now());

      if (message.isNotEmpty) {
        add(MessageReceived(message, senderId, time));
      }
    });
  }

  FutureOr<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    String? userId = await _getUserId();
    String? driverId = await _getDriverId();
    String? tripId = await _getTripId();

    final time = _formatTime(DateTime.now());

    if (userId != null && driverId != null && tripId != null) {
      ChatModel chatModel=ChatModel(senderId:driverId, recieverId: userId, message:event.message, tripId:tripId, senderType: 'driver', driverId: driverId, userId: userId);
      chatService.sendMessage(
    chatModel
      );

      _sentMessages.add({
        'message': event.message,
        'isSender': true,
        'time': time,
      });
    } else {
      emit(ChatError(message: 'User ID not found'));
    }
  }

  FutureOr<void> _onMessageReceived(
      MessageReceived event, Emitter<ChatState> emit) async {
    String? driverId = await _getDriverId();

    _receivedMessages.add({
      'message': event.message,
      'isSender': event.senderid == driverId,
      'time': event.time,
    });

    emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
  }

  FutureOr<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('accesstoken');
      final tripId = await _getTripId();
      if (kDebugMode) {
        print('token from get message:$token');
      }
      List<dynamic> messages = await chatService.getMessages(
        token: token ?? 'get message token not found',
        tripId: tripId ?? 'get message tripid not found',
      );
      if (kDebugMode) {
        print(' the getted message from database:$messages');
      }
      String? driverId = await _getDriverId();

      _receivedMessages = messages.map((e) {
        final timestamp = e['createdAt'] != null
            ? DateTime.parse(e['createdAt'])
                .toUtc()
                .add(const Duration(hours: 5, minutes: 30)) // Convert UTC to IST

            : DateTime.now();

        return {
          'message': e['message'],
          'isSender': e['senderId'] == driverId,
          'time': _formatTime(timestamp),
        };
      }).toList();

      emit(ChatReceivedMessagesUpdated(messages: _receivedMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }
}
