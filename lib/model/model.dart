// class RideRequest {
//   final String userId;
//   final String tripStatus;
//   final String requestStatus;
//   final List<String> rejectedDrivers;
//   final double fare;
//   final Location startLocation;
//   final Location endLocation;
//   final int distance;
//   final int duration;
//   final String pickUpLocation;
//   final String dropOffLocation;
//   final bool isPaymentComplete;
//   final String paymentMethod;
//   final String tripId;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   RideRequest({
//     required this.userId,
//     required this.tripStatus,
//     required this.requestStatus,
//     required this.rejectedDrivers,
//     required this.fare,
//     required this.startLocation,
//     required this.endLocation,
//     required this.distance,
//     required this.duration,
//     required this.pickUpLocation,
//     required this.dropOffLocation,
//     required this.isPaymentComplete,
//     required this.paymentMethod,
//     required this.tripId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // Factory method to create a RideRequest from a map
//   factory RideRequest.fromMap(Map<String, dynamic> map) {
//     return RideRequest(
//       userId: map['userId'],
//       tripStatus: map['tripStatus'],
//       requestStatus: map['requestStatus'],
//       rejectedDrivers: List<String>.from(map['rejectedDrivers']),
//       fare: map['fare'].toDouble(),
//       startLocation: Location.fromMap(map['startLocation']),
//       endLocation: Location.fromMap(map['endLocation']),
//       distance: map['distance'],
//       duration: map['duration'],
//       pickUpLocation: map['pickUpLocation'],
//       dropOffLocation: map['dropOffLocation'],
//       isPaymentComplete: map['isPaymentComplete'],
//       paymentMethod: map['paymentMethod'],
//       tripId: map['_id'],
//       createdAt: DateTime.parse(map['createdAt']),
//       updatedAt: DateTime.parse(map['updatedAt']),
//     );
//   }

//   // Method to convert the object to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'tripStatus': tripStatus,
//       'requestStatus': requestStatus,
//       'rejectedDrivers': rejectedDrivers,
//       'fare': fare,
//       'startLocation': startLocation.toMap(),
//       'endLocation': endLocation.toMap(),
//       'distance': distance,
//       'duration': duration,
//       'pickUpLocation': pickUpLocation,
//       'dropOffLocation': dropOffLocation,
//       'isPaymentComplete': isPaymentComplete,
//       'paymentMethod': paymentMethod,
//       '_id': tripId,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }

// class Location {
//   final String type;
//   final List<double> coordinates;

//   Location({required this.type, required this.coordinates});

//   factory Location.fromMap(Map<String, dynamic> map) {
//     return Location(
//       type: map['type'],
//       coordinates: List<double>.from(map['coordinates']),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//     };
//   }
// }
