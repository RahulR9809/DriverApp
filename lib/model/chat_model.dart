

class ChatModel {
  final String senderId;
  final String recieverId;
  final String message;
  final String tripId;
  final String senderType;
  final String driverId;
  final String userId;

  ChatModel({required this.senderId,required this.recieverId,required this.message,required this.tripId,required this.senderType,required this.driverId,required this.userId});

  Map<String, dynamic> toJson() {
    return {
         "senderId": senderId,
      "recieverId": recieverId,
      "message": message,
      "tripId": tripId,
      "senderType": senderType,
      "driverId": driverId,
      "userId": userId,
    };
  }
}