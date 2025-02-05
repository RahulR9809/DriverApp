class RideAcceptModel{
  final String tripid;
  final String driverid;
  final String status;

  RideAcceptModel({required this.tripid, required this.driverid, required this.status});
Map<String,dynamic> toJson(){
  return 
  {
      'tripId': tripid,
        'driverId': driverid,
        'status': status,
  };
}
}