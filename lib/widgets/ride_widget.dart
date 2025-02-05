import 'dart:async';
import 'package:employerapp/controllers/map_bloc/animation_state_bloc.dart';
import 'package:employerapp/controllers/ride_bloc/ride_bloc.dart';
import 'package:employerapp/controllers/ride_bloc/ride_event.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LocationService {
  Future<String> getCurrentLocation({
    double? predefinedLatitude,
    double? predefinedLongitude,
  }) async {
    try {
      if (predefinedLatitude != null && predefinedLongitude != null) {
        return await _getLocationDetails(
            predefinedLatitude, predefinedLongitude);
      }

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

  Future<String> _getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude).timeout(
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

class ReachedDialog {
  static void showLocationReachedDialog(
    BuildContext context, {
    required String title,
    required String text,
    VoidCallback? onConfirm,
  }) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.success,
      title: title,
      text: text,
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        // Pop the dialog first
        Navigator.of(context).pop();

        // Safely call onConfirm if it's provided
        if (onConfirm != null) {
          onConfirm();
        }
      },
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.green.shade800,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.red.shade700,
        thumbColor: MaterialStateProperty.all(Colors.blue.shade600),
        trackColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 115, 117, 122)),
        splashRadius: 30.0,
        overlayColor:
            MaterialStateProperty.all(Colors.green.shade300.withOpacity(0.5)),
      ),
    );
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

    final tripDetails = widget.rideData;

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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(26)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Heading to Drop Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 30),
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
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
                BlocBuilder<AnimationStateBloc, AnimationState>(
                  builder: (context, state) {
                    return state.isAnimationComplete
                        ? ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  title: 'Complete Ride',
                                  content:
                                      'Are you sure you want to complete this ride?',
                                  onConfirm: () {
                                    context
                                        .read<RideBloc>()
                                        .add(CompleteRideEvent());
                                    if (kDebugMode) {
                                      print('Ride Completed');
                                    }

                                    context
                                        .read<AnimationStateBloc>()
                                        .add(ResetAnimation());
                                    if (kDebugMode) {
                                      print('Animation Reset');
                                    }

                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "Complete Ride",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
