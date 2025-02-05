class CompleteRideModel {
  final String tripId;
  final String userId;

  CompleteRideModel({required this.tripId, required this.userId});

Map<String,dynamic>tojson(){
  return {
   'tripId': tripId,
        'userId': userId,
  };
}
}