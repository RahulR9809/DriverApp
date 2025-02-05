class RejectRideModel{
  final String driverId;
  final String status;
  final String tripId;


  RejectRideModel({required this.driverId, required this.status, required this.tripId});
  Map<String,dynamic>tojson(){
    return {
 'driverId': driverId,
        'status': status,
        'tripId': tripId,
    };
  }
  }