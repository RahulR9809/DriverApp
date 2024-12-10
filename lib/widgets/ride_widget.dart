import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox;


class LocationService {
  /// Get the current location or use predefined coordinates
  Future<String> getCurrentLocation({
    double? predefinedLatitude,
    double? predefinedLongitude,
  }) async {
    try {
      // Use predefined coordinates if provided
      if (predefinedLatitude != null && predefinedLongitude != null) {
        return await _getLocationDetails(predefinedLatitude, predefinedLongitude);
      }

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception("Location fetch timeout exceeded.");
      });

      return await _getLocationDetails(position.latitude, position.longitude);
    } catch (e) {
      throw Exception("Failed to get location: ${e.toString()}");
    }
  }

  /// Get location details (address) from coordinates
  Future<String> _getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Geocoding timeout exceeded.");
        },
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        throw Exception("No location details found.");
      }
    } catch (e) {
      throw Exception("Failed to fetch location details: ${e.toString()}");
    }
  }
}



class MapboxWidget extends StatelessWidget {
  final double initialLatitude;
  final double initialLongitude;
  final MapController controller;

  const MapboxWidget({
    super.key,
    this.initialLatitude = 9.968677, 
    this.initialLongitude = 76.318354,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Ensure token is valid
        initialCameraPosition: CameraPosition(
          target: LatLng(initialLatitude, initialLongitude),
          zoom: 14.0,
        ),
        styleString: MapboxStyles.MAPBOX_STREETS, // Try using a direct style URL
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
      ),
    );
  }
}

class RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> rideRequestData;
  final VoidCallback onAccept;
  
  final String livelocation;
  const RideRequestCard({required this.rideRequestData, required this.onAccept, super.key, required this.livelocation, });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow:const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Ride Request', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                  children: [
                    Icon(Icons.circle, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rideRequestData['pickUpLocation'],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: List.generate(3, (index) => const Text('.', style: TextStyle(fontWeight: FontWeight.w900))),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rideRequestData['dropOffLocation'] ?? '8 County Road 11/6, Mannington, WY',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Transform.scale(
        scale: 1.5, // Makes the switch larger
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.green.shade800,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.red.shade700,
          thumbColor: MaterialStateProperty.all(Colors.blue.shade600), // Corrected here
          trackColor: MaterialStateProperty.all(const Color.fromARGB(255, 115, 117, 122)), // Corrected here
          splashRadius: 30.0, // Adds a nice splash effect
          overlayColor: MaterialStateProperty.all(Colors.green.shade300.withOpacity(0.5)), // Corrected here
        ),
      ),
    );
  }
}













// class RideDetailsSheet extends StatelessWidget {
//   final Map<String, dynamic>? rideData;
//   final bool isRideAccepted;

//   const RideDetailsSheet({Key? key, required this.rideData, this.isRideAccepted = false}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (rideData == null) {
//       return const Center(child: Text('No ride data available.'));
//     }

//     // Safely access nested properties with default fallbacks
//     final driverDetails = rideData?['driverId'] ?? {};
//     final driverName = driverDetails['name'] ?? 'Unknown';
//     final profileImg = driverDetails['profileImg'] ?? '';
//     final pickUpLocation = rideData?['pickUpLocation'] ?? 'Unknown';
//     final driverLocation =
//         driverDetails['currentLocation']?['coordinates']?.toString() ?? 'Unknown';
//     final pickUpTime = rideData?['pickUpTime'] ?? 'Unknown';

//     // Build the UI
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 10,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           // Display Driver Details
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 child: Icon(Icons.person),
//                 backgroundColor: Colors.grey.shade200,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         driverName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5, height: 20),
//           // Pickup Location
//           Row(
//             children: [
//               const Icon(Icons.location_pin, color: Colors.orange),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Pickup Location',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                     Text('$pickUpLocation at $pickUpTime',
//                         style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5, height: 20),
//           // Action Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context); // Close the sheet
//                 },
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 label: const Text('Close'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
