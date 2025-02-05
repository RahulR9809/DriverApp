import 'package:employerapp/controllers/ride_bloc/ride_bloc.dart';
import 'package:employerapp/repository/chat_socketcontroller.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/controllers/ride_bloc/ride_state.dart';
import 'package:employerapp/views/Nav/main_page.dart';
import 'package:employerapp/widgets/ride_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:employerapp/views/map/map_pages.dart';
import 'package:employerapp/widgets/refactored_widget.dart';

class RideStartpage extends StatefulWidget {
  final Map<String, dynamic>? rideData;

  const RideStartpage({super.key, required this.rideData});

  @override
  State<RideStartpage> createState() => _RideStartpageState();
}

class _RideStartpageState extends State<RideStartpage> {
  DriverSocketChatService driverSocketChatService = DriverSocketChatService();

  @override
  Widget build(BuildContext context) {
    try {
      final rideData = widget.rideData;
      if (rideData == null) throw Exception("Ride data is missing.");

      final startLocationRaw = rideData['startLocation']?['coordinates'];
      final endLocationRaw = rideData['endLocation']?['coordinates'];

      if (startLocationRaw == null || startLocationRaw.length < 2) {
        throw Exception("Invalid start location coordinates.");
      }

      if (endLocationRaw == null || endLocationRaw.length < 2) {
        throw Exception("Invalid end location coordinates.");
      }

      LatLng startPoint = LatLng(startLocationRaw[0], startLocationRaw[1]);
      LatLng endPoint = LatLng(endLocationRaw[0], endLocationRaw[1]);

      return BlocListener<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideCompletedState) {
            showSnackBar(
                context, 'Ride Completed successfully', CustomColors.green);
            Future.delayed(const Duration(seconds: 3));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
          } else if (state is RideErrorState) {
            showSnackBar(context, 'Error Completing Ride', CustomColors.red);
          }
        },
        child: SafeArea(
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
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
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
                const Text(
                  "An error occurred:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
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
