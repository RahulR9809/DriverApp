part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}




class ChatSocketConnectedevent extends ChatEvent{
final String driverId;

  ChatSocketConnectedevent({required this.driverId});
}

class ChatSocketDisconnectedevent extends ChatEvent{}



class MessageReceived extends ChatEvent {
  final String message;

  MessageReceived(this.message);
}



class SendMessage extends ChatEvent {
  final String message;
  final String? userid;
  final String? tripId;
  final String? token;

  SendMessage({
    required this.message,
    this.userid,
    this.tripId,
     this.token,
  });
}

// class MessageReceived extends ChatEvent {
//   final String message;

//   MessageReceived(this.message);
// }

class LoadMessages extends ChatEvent {
  final String token;
  final String tripId;

  LoadMessages({required this.token, required this.tripId});
}