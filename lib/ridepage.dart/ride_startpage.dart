import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/ridepage.dart/map/map_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RideStartpage extends StatefulWidget {
  final Map<String, dynamic>? rideData; // Accept rideData as input

  const RideStartpage({super.key, required this.rideData});

  @override
  State<RideStartpage> createState() => _RideStartpageState();
}


class _RideStartpageState extends State<RideStartpage> {
  DriverSocketChatService driverSocketChatService = DriverSocketChatService();

  @override
  Widget build(BuildContext context) {
    try {
      // Access rideData passed to the widget
      final rideData = widget.rideData;

      if (rideData == null) {
        print(rideData);
        throw Exception("Ride data is missing.");
      }

      // Extract start and end locations
      final startLocationRaw = rideData['startLocation']?['coordinates'];
      final endLocationRaw = rideData['endLocation']?['coordinates'];

      // Validate and convert raw data to LatLng if available
      if (startLocationRaw == null || startLocationRaw.length < 2) {
        throw Exception("Invalid start location coordinates.");
      }

      if (endLocationRaw == null || endLocationRaw.length < 2) {
        throw Exception("Invalid end location coordinates.");
      }

      LatLng startPoint = LatLng(startLocationRaw[0], startLocationRaw[1]);
      LatLng endPoint = LatLng(endLocationRaw[0], endLocationRaw[1]);

      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
      
              MapboxDropSimulation(
                startPoint: startPoint,
                endPoint: endPoint,
              ),
                          Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RidestartedBottomBar(rideData: rideData),
                )
            ],
          ),
        ),
      );
    } catch (e) {
      // Handle exceptions and display an error message
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  "An error occurred:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Optionally navigate back or retry
                    Navigator.of(context).pop();
                  },
                  child: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}







class RidestartedBottomBar extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const RidestartedBottomBar({super.key, required this.rideData});

  @override
  _RidestartedBottomBarState createState() => _RidestartedBottomBarState();
}

class _RidestartedBottomBarState extends State<RidestartedBottomBar> {



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Access trip details from the rideData
    final tripDetails = widget.rideData;

    // ✅ Extract required data
    final String fare = (tripDetails['fare'] ?? 0.0).toStringAsFixed(2);
    final String pickUpLocation = tripDetails['pickUpLocation'] ?? 'Unknown';
    final String dropOffLocation = tripDetails['dropOffLocation'] ?? 'Unknown';
    final String totalDistance = tripDetails['distance'].toString();
    final String duration = tripDetails['duration'].toString();



    return SizedBox(
      height: screenHeight * 0.7,
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                // 🚗 Driver Info Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.person, // Pass your icon here
                        size: 30,
                        color: Colors.black, // Adjust the color as needed
                      ),
                    ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Heading to Drop Location',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                         
                          ],
                        ),
                      ],
                    ),
                    // 📅 Date-Time
                   
                  ],
                ),
                const Divider(thickness: 1.5, height: 30),
                // 📍 Pickup Point
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pickup Point',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            pickUpLocation,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // 📍 Drop-off Point
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Drop-off Point',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            dropOffLocation,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 30),
                // 📊 Fare & Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '₹$fare',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Fare Estimate',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$totalDistance KM',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Total Distance',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$duration min',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Duration',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 30),
ElevatedButton(
  onPressed: () {
    // Add your complete ride logic here
    print("Ride completed");
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
    shadowColor: Colors.black, // Shadow color
    elevation: 5, // Elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded corners
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
  ),
  child: Text(
    "Complete Ride",
    style: TextStyle(
      fontSize: 18, // Font size
      fontWeight: FontWeight.bold, // Bold text
    ),
  ),
)
              ],
            ),
          );
        },
      ),
    );
  }
}

