class RideCancelledModel {
  final String tripId;
  final String userId;

  RideCancelledModel({required this.tripId, required this.userId});

Map<String,dynamic>tojson(){
  return {
   'tripId': tripId,
        'userId': userId,
  };
}
}