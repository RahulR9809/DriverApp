class StartRideModel {
  final String tripOtp;
  final String tripId;

  StartRideModel({required this.tripOtp, required this.tripId});

Map<String,dynamic>toJson(){
  return {
  'tripOtp': tripOtp,
        'tripId': tripId,
  };
}
}